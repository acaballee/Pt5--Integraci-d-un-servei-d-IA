import { AIStrategy } from './AIStrategy.js';

export class GeminiStrategy extends AIStrategy {
    async processReceipt(text) {
        if (!this.apiKey) throw new Error("API Key de Gemini no configurada.");

        const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${this.apiKey}`;
        
        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                contents: [{
                    parts: [{ text: this.getPrompt(text) }]
                }]
            })
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(`Error Gemini API: ${error.error?.message || response.statusText}`);
        }

        const data = await response.json();
        const content = data.candidates[0].content.parts[0].text;
        
        // Netegem el possible markdown del JSON
        const jsonMatch = content.match(/\{[\s\S]*\}/);
        if (!jsonMatch) throw new Error("No s'ha pogut extreure JSON de la resposta de Gemini.");
        
        return JSON.parse(jsonMatch[0]);
    }
}
