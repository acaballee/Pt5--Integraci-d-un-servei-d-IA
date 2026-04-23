/**
 * Base class for AI Strategy
 * Following the Strategy Pattern for PT5
 */
export class AIStrategy {
    constructor(apiKey) {
        this.apiKey = apiKey;
    }

    /**
     * @param {string} text - The raw receipt text
     * @returns {Promise<object>} - Structured JSON data
     */
    async processReceipt(text) {
        throw new Error("Method 'processReceipt()' must be implemented.");
    }

    getPrompt(text) {
        return `
        Actua com un extractor de dades de tiquets de compra. 
        Analitza el següent text i retorna UNICAMENT un objecte JSON amb aquest format exactament:
        {
          "establishment": "Nom de la botiga o restaurant",
          "date": "DD/MM/YYYY",
          "total": 0.00,
          "category": "Alimentació | Transport | Oci | Altres",
          "items": [{"name": "producte", "price": 0.00}]
        }
        
        Text del tiquet:
        "${text}"
        `;
    }
}
