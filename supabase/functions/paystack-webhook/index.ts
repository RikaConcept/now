import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

interface PaystackEvent {
  event: string;
  data: {
    reference: string;
    amount: number;
    currency: string;
    status: string;
    customer: {
      email: string;
    };
    metadata: {
      member_id: string;
      member_status: string;
      items: string;
    };
  };
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const signature = req.headers.get("x-paystack-signature");
    const paystackSecretKey = Deno.env.get("PAYSTACK_SECRET_KEY");

    if (!signature || !paystackSecretKey) {
      return new Response(
        JSON.stringify({ error: "Invalid request" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const body = await req.text();
    const encoder = new TextEncoder();
    const key = await crypto.subtle.importKey(
      "raw",
      encoder.encode(paystackSecretKey),
      { name: "HMAC", hash: "SHA-512" },
      false,
      ["sign"]
    );

    const signatureBuffer = await crypto.subtle.sign(
      "HMAC",
      key,
      encoder.encode(body)
    );

    const computedSignature = Array.from(new Uint8Array(signatureBuffer))
      .map(b => b.toString(16).padStart(2, "0"))
      .join("");

    if (computedSignature !== signature) {
      return new Response(
        JSON.stringify({ error: "Invalid signature" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const event: PaystackEvent = JSON.parse(body);

    if (event.event === "charge.success") {
      const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
      const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
      const supabase = createClient(supabaseUrl, supabaseServiceKey);

      const { member_id, member_status, items } = event.data.metadata;

      const { error: orderError } = await supabase.from("orders").insert({
        member_id,
        amount: event.data.amount / 100,
        currency: event.data.currency,
        status: "completed",
        payment_method: "paystack_mobile_money",
        transaction_reference: event.data.reference,
        items: items ? JSON.parse(items) : [],
      });

      if (orderError) {
        console.error("Error creating order:", orderError);
      }

      if (member_status === "pending") {
        const { error: memberError } = await supabase
          .from("members")
          .update({ status: "active" })
          .eq("id", member_id);

        if (memberError) {
          console.error("Error updating member status:", memberError);
        }
      }

      await supabase.from("notifications").insert({
        member_id,
        type: "payment_success",
        title: "Paiement réussi",
        message: `Votre paiement de ${event.data.amount / 100} ${event.data.currency} via Mobile Money a été confirmé.`,
        read: false,
      });
    }

    return new Response(
      JSON.stringify({ received: true }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Webhook error:", error);
    return new Response(
      JSON.stringify({ error: error instanceof Error ? error.message : "Internal server error" }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});