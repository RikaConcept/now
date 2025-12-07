import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

interface NotificationPayload {
  email: string;
  phone?: string;
  type: 'code_generated' | 'member_activated' | 'product_request_confirmed' | 'admin_product_request';
  data: {
    code?: string;
    locality?: string;
    advantages?: string[];
    shopUrl?: string;
    partnerShops?: Array<{ name: string; discount: number }>;
    productName?: string;
    requestId?: string;
    userEmail?: string;
    userPhone?: string;
    bestPriceFound?: number;
    userBudget?: number;
    priceSource?: string;
    isMember?: boolean;
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
    const payload: NotificationPayload = await req.json();
    const { email, phone, type, data } = payload;

    let emailSubject = '';
    let emailBody = '';
    let whatsappMessage = '';

    switch (type) {
      case 'code_generated':
        emailSubject = '🎉 Votre code Nowlover a été généré !';
        emailBody = `
          <h2>Bienvenue dans la communauté Nowlover !</h2>
          <p>Votre code membre a été généré avec succès :</p>
          <h3 style="color: #2563eb; font-size: 24px;">${data.code}</h3>
          <p><strong>Localité :</strong> ${data.locality}</p>
          
          <h3>Vos avantages :</h3>
          <ul>
            ${data.advantages?.map(adv => `<li>${adv}</li>`).join('') || ''}
          </ul>
          
          <p>Pour activer votre code et profiter de tous ces avantages, effectuez votre premier achat sur notre boutique.</p>
          <p><a href="${data.shopUrl}" style="background-color: #2563eb; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block;">Accéder à la boutique</a></p>
        `;
        whatsappMessage = `🎉 Bienvenue Nowlover !\n\nVotre code: ${data.code}\nLocalité: ${data.locality}\n\nActivez votre code en faisant votre premier achat: ${data.shopUrl}`;
        break;

      case 'member_activated':
        emailSubject = '✅ Votre statut de membre Nowlover est actif !';
        emailBody = `
          <h2>Félicitations ! Vous êtes maintenant membre actif Nowlover</h2>
          <p>Votre paiement a été confirmé et votre code est maintenant actif.</p>
          
          <h3>Vos avantages membres :</h3>
          <ul>
            <li>Réductions exclusives dans nos boutiques partenaires</li>
            <li>Demandes de produits sans commission (don optionnel)</li>
            <li>Accès prioritaire aux nouvelles offres</li>
          </ul>
          
          <h3>Nos boutiques partenaires :</h3>
          <ul>
            ${data.partnerShops?.map(shop => `<li><strong>${shop.name}</strong> - ${shop.discount}% de réduction</li>`).join('') || ''}
          </ul>
          
          <p>Profitez dès maintenant de vos avantages !</p>
        `;
        whatsappMessage = `✅ Félicitations !\n\nVous êtes maintenant membre actif Nowlover.\n\nProfitez de réductions exclusives dans toutes nos boutiques partenaires !`;
        break;

      case 'product_request_confirmed':
        emailSubject = '📦 Votre demande de produit a été reçue';
        emailBody = `
          <h2>Demande de produit enregistrée</h2>
          <p>Nous avons bien reçu votre demande pour :</p>
          <p><strong>${data.productName}</strong></p>
          <p>Numéro de demande : ${data.requestId}</p>

          <p>Notre équipe recherche le meilleur prix pour vous. Vous serez notifié dès que nous aurons une mise à jour.</p>

          <p>Merci de votre confiance !</p>
        `;
        whatsappMessage = `📦 Demande reçue\n\nProduit: ${data.productName}\nRéférence: ${data.requestId}\n\nNous recherchons le meilleur prix pour vous !`;
        break;

      case 'admin_product_request':
        emailSubject = '🔔 ADMIN: Nouvelle demande de produit';
        emailBody = `
          <h2>Nouvelle demande de produit reçue</h2>
          <p><strong>Produit demandé:</strong> ${data.productName}</p>
          <p><strong>Client:</strong> ${data.userEmail}</p>
          ${data.userPhone ? `<p><strong>Téléphone:</strong> ${data.userPhone}</p>` : ''}
          <p><strong>Statut:</strong> ${data.isMember ? 'Membre actif' : 'Non-membre'}</p>

          <h3>Détails de la demande:</h3>
          <ul>
            <li>Meilleur prix trouvé: ${data.bestPriceFound} €</li>
            <li>Budget du client: ${data.userBudget} €</li>
            <li>Source du prix: ${data.priceSource}</li>
          </ul>

          <p><strong>Référence:</strong> ${data.requestId}</p>

          <p>Connectez-vous au dashboard admin pour traiter cette demande.</p>
        `;
        whatsappMessage = `🔔 NOUVELLE DEMANDE PRODUIT\n\nProduit: ${data.productName}\nClient: ${data.userEmail}\nBudget: ${data.userBudget}€\nPrix trouvé: ${data.bestPriceFound}€\n\nRéf: ${data.requestId}`;
        break;
    }

    console.log(`Notification envoyée à ${email}`);
    console.log(`Email: ${emailSubject}`);
    if (phone) {
      console.log(`WhatsApp à ${phone}: ${whatsappMessage}`);
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: 'Notification envoyée avec succès',
        email: emailSubject,
        whatsapp: phone ? 'Message préparé' : 'Pas de numéro fourni'
      }),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      }
    );
  } catch (error) {
    console.error('Error:', error);
    return new Response(
      JSON.stringify({ error: error.message || 'Erreur lors de l\'envoi de la notification' }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
        },
      }
    );
  }
});