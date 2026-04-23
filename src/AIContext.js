/**
 * Context class that uses the AI strategies
 * Following the Strategy Pattern for PT5
 */
export class AIContext {
    constructor() {
        this.strategy = null;
    }

    /**
     * Set the current strategy
     * @param {AIStrategy} strategy 
     */
    setStrategy(strategy) {
        this.strategy = strategy;
    }

    /**
     * Process receipt using the selected strategy
     * @param {string} text 
     * @returns {Promise<object>}
     */
    async process(text) {
        if (!this.strategy) {
            throw new Error("Cap estratègia d'IA seleccionada.");
        }
        return await this.strategy.processReceipt(text);
    }
}
