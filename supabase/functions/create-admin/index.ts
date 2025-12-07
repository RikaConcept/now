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
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    );

    const adminEmail = "admin@nowlovers.com";
    const adminPassword = "NOW!Lovers2025Secure";

    const { data: existingUser } = await supabaseAdmin.auth.admin.listUsers();
    const userExists = existingUser?.users.some(u => u.email === adminEmail);

    if (userExists) {
      return new Response(
        JSON.stringify({ 
          success: false, 
          message: "L'utilisateur admin existe déjà" 
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        }
      );
    }

    const { data: newUser, error: createError } = await supabaseAdmin.auth.admin.createUser({
      email: adminEmail,
      password: adminPassword,
      email_confirm: true,
      user_metadata: {
        is_admin: true
      }
    });

    if (createError) {
      throw createError;
    }

    if (!newUser.user) {
      throw new Error("Aucun utilisateur créé");
    }

    const { error: adminError } = await supabaseAdmin
      .from("admin_users")
      .insert({
        user_id: newUser.user.id,
        role: "admin"
      });

    if (adminError) {
      await supabaseAdmin.auth.admin.deleteUser(newUser.user.id);
      throw adminError;
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: "Admin créé avec succès",
        user_id: newUser.user.id
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      }
    );

  } catch (error: any) {
    console.error("Error creating admin:", error);
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: error.message || "Erreur lors de la création de l'admin" 
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      }
    );
  }
});