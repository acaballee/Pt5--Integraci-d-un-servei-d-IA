import { AIStrategy } from './AIStrategy.js';

export class GrokStrategy extends AIStrategy {
    async processReceipt(text) {
        if (!this.apiKey) throw new Error("API Key de Grok (xAI) no configurada.");

        const url = "https://api.x.ai/v1/chat/completions";
        
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${this.apiKey}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                model: "grok-2-1212",
                messages: [
                    { role: "system", content: "Ets un expert en extracció de dades de tiquets. Respon sempre en JSON." },
                    { role: "user", content: this.getPrompt(text) }
                ],
                stream: false
            })
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(`Error xAI API: ${error.error?.message || response.statusText}`);
        }

        const data = await response.json();
        const content = data.choices[0].message.content;
        
        // Netegem el possible markdown del JSON
        const jsonMatch = content.match(/\{[\s\S]*\}/);
        if (!jsonMatch) throw new Error("No s'ha pogut extreure JSON de la resposta de Grok.");
        
        return JSON.parse(jsonMatch[0]);
    }
}
