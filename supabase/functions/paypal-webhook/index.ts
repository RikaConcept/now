import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const webhookEvent = await req.json();
    console.log("PayPal webhook received:", webhookEvent.event_type);

    // Handle different PayPal webhook events
    if (webhookEvent.event_type === "CHECKOUT.ORDER.APPROVED") {
      const orderId = webhookEvent.resource.id;
      const customId = webhookEvent.resource.purchase_units?.[0]?.custom_id;

      console.log("Order approved:", orderId, "for member:", customId);

      // Update member status if this is their first purchase
      if (customId) {
        const { data: member } = await supabase
          .from("members")
          .select("status")
          .eq("id", customId)
          .maybeSingle();

        if (member && member.status === "pending") {
          await supabase
            .from("members")
            .update({ status: "active" })
            .eq("id", customId);

          console.log("Member activated:", customId);
        }
      }
    } else if (webhookEvent.event_type === "PAYMENT.CAPTURE.COMPLETED") {
      const captureId = webhookEvent.resource.id;
      const customId = webhookEvent.resource.custom_id;
      const amount = webhookEvent.resource.amount.value;

      console.log("Payment captured:", captureId, "Amount:", amount);

      // You can add additional logic here, like:
      // - Record the transaction in your database
      // - Send confirmation emails
      // - Update inventory
    } else if (webhookEvent.event_type === "PAYMENT.CAPTURE.DENIED") {
      console.log("Payment denied:", webhookEvent.resource.id);
    }

    return new Response(
      JSON.stringify({ received: true }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("PayPal webhook error:", error);
    return new Response(
      JSON.stringify({ error: error instanceof Error ? error.message : "Webhook processing failed" }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});