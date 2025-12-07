import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

interface CheckoutRequest {
  amount: string;
  currency: string;
  items: Array<{
    name: string;
    unit_amount: string;
    quantity: number;
    description?: string;
  }>;
  return_url: string;
  cancel_url: string;
  metadata?: Record<string, any>;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const paypalClientId = Deno.env.get("PAYPAL_CLIENT_ID");
    const paypalClientSecret = Deno.env.get("PAYPAL_CLIENT_SECRET");
    const paypalMode = Deno.env.get("PAYPAL_MODE") || "sandbox";

    console.log("PayPal Configuration Check:", {
      hasClientId: !!paypalClientId,
      hasClientSecret: !!paypalClientSecret,
      mode: paypalMode,
      clientIdLength: paypalClientId?.length,
    });

    if (!paypalClientId || !paypalClientSecret) {
      console.error("Missing PayPal credentials");
      throw new Error("PayPal credentials not configured");
    }

    const body: CheckoutRequest = await req.json();
    const { amount, currency, items, return_url, cancel_url, metadata } = body;

    console.log("Checkout request:", { amount, currency, itemCount: items.length });

    if (!amount || !currency || !items || !return_url || !cancel_url) {
      return new Response(
        JSON.stringify({ error: "Missing required fields" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const baseUrl = paypalMode === "production" 
      ? "https://api-m.paypal.com"
      : "https://api-m.sandbox.paypal.com";

    console.log("Using PayPal API:", baseUrl);

    // Get PayPal access token
    const authResponse = await fetch(
      `${baseUrl}/v1/oauth2/token`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          Authorization: `Basic ${btoa(`${paypalClientId}:${paypalClientSecret}`)}`,
        },
        body: "grant_type=client_credentials",
      }
    );

    if (!authResponse.ok) {
      const errorText = await authResponse.text();
      console.error("PayPal auth failed:", {
        status: authResponse.status,
        statusText: authResponse.statusText,
        error: errorText,
      });
      throw new Error(`Failed to authenticate with PayPal: ${authResponse.status} - ${errorText}`);
    }

    const authData = await authResponse.json();
    const accessToken = authData.access_token;
    console.log("PayPal authentication successful");

    // Create PayPal order
    const orderPayload = {
      intent: "CAPTURE",
      purchase_units: [
        {
          amount: {
            currency_code: currency,
            value: amount,
            breakdown: {
              item_total: {
                currency_code: currency,
                value: amount,
              },
            },
          },
          items: items.map(item => ({
            name: item.name,
            description: item.description || item.name,
            unit_amount: {
              currency_code: currency,
              value: item.unit_amount,
            },
            quantity: item.quantity.toString(),
          })),
          custom_id: metadata?.member_id || "",
        },
      ],
      application_context: {
        return_url,
        cancel_url,
        brand_name: "NOW!Lovers",
        user_action: "PAY_NOW",
      },
    };

    console.log("Creating PayPal order...");

    const orderResponse = await fetch(
      `${baseUrl}/v2/checkout/orders`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(orderPayload),
      }
    );

    if (!orderResponse.ok) {
      const error = await orderResponse.json();
      console.error("PayPal order creation failed:", error);
      throw new Error(error.message || "Failed to create PayPal order");
    }

    const orderData = await orderResponse.json();
    console.log("PayPal order created:", orderData.id);

    const approvalUrl = orderData.links.find(
      (link: { rel: string }) => link.rel === "approve"
    )?.href;

    if (!approvalUrl) {
      console.error("No approval URL in response", orderData);
      throw new Error("No approval URL returned from PayPal");
    }

    console.log("Approval URL generated successfully");

    return new Response(
      JSON.stringify({
        url: approvalUrl,
        order_id: orderData.id,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Error in paypal-checkout:", error);
    return new Response(
      JSON.stringify({ error: error instanceof Error ? error.message : "Internal server error" }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});