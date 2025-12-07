import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

interface CheckoutRequest {
  amount: number;
  currency: string;
  email: string;
  phone?: string;
  mobile_money_provider?: 'mtn' | 'orange' | 'moov' | 'wave';
  items: Array<{
    name: string;
    amount: number;
    quantity: number;
  }>;
  callback_url: string;
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
    const paystackSecretKey = Deno.env.get("PAYSTACK_SECRET_KEY");

    if (!paystackSecretKey) {
      throw new Error("PAYSTACK_SECRET_KEY not configured");
    }

    const body: CheckoutRequest = await req.json();
    const { amount, currency, email, phone, mobile_money_provider, items, callback_url, metadata } = body;

    if (!amount || !email || !callback_url) {
      return new Response(
        JSON.stringify({ error: "Missing required fields" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const channels = ["mobile_money", "card"];

    const paystackResponse = await fetch(
      "https://api.paystack.co/transaction/initialize",
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${paystackSecretKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email,
          amount: amount,
          currency: currency || "XOF",
          callback_url,
          ...(phone && { phone }),
          metadata: {
            ...metadata,
            mobile_money_provider: mobile_money_provider || "any",
            phone: phone || "",
            items: JSON.stringify(items),
            custom_fields: [
              {
                display_name: "Cart Items",
                variable_name: "cart_items",
                value: items.map(item => `${item.name} (x${item.quantity})`).join(", "),
              },
              {
                display_name: "Payment Method",
                variable_name: "payment_method",
                value: mobile_money_provider ? `${mobile_money_provider} Money` : "Mobile Money",
              },
              ...(phone ? [{
                display_name: "Phone Number",
                variable_name: "phone_number",
                value: phone,
              }] : []),
            ],
          },
          channels: channels,
        }),
      }
    );

    if (!paystackResponse.ok) {
      const error = await paystackResponse.json();
      console.error("Paystack error:", error);
      throw new Error(error.message || "Failed to initialize payment");
    }

    const data = await paystackResponse.json();

    return new Response(
      JSON.stringify({
        url: data.data.authorization_url,
        reference: data.data.reference,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Error:", error);
    return new Response(
      JSON.stringify({ error: error instanceof Error ? error.message : "Internal server error" }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});