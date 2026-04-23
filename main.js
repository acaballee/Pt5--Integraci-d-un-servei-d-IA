import { AIContext } from './src/AIContext.js';
import { GeminiStrategy } from './src/strategies/GeminiStrategy.js';
import { GrokStrategy } from './src/strategies/GrokStrategy.js';
import { GEMINI_KEY, GROK_KEY } from './config.js';

document.addEventListener('DOMContentLoaded', () => {
    const aiContext = new AIContext();
    
    // Les claus d'API s'importen de config.js (ignorat per git)
    
    // UI Elements
    const providerSelect = document.getElementById('provider');
    const receiptText = document.getElementById('receiptText');
    const btnProcess = document.getElementById('btnProcess');
    const loader = document.getElementById('loader');
    const btnText = btnProcess.querySelector('.btn-text');
    const errorMsg = document.getElementById('errorMsg');
    
    const resultsContent = document.getElementById('resultsContent');
    const placeholder = document.getElementById('placeholder');
    
    // Result Display Elements
    const resEstablishment = document.getElementById('resEstablishment');
    const resDate = document.getElementById('resDate');
    const resTotal = document.getElementById('resTotal');
    const resCategory = document.getElementById('resCategory');
    const resItems = document.getElementById('resItems');
    const exampleBtns = document.querySelectorAll('.btn-example');

    // Manejar botons d'exemple
    exampleBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const rawText = btn.getAttribute('data-text');
            receiptText.value = rawText.split('\\n').join('\n');
            errorMsg.style.display = 'none';
        });
    });

    providerSelect.addEventListener('change', () => {
        errorMsg.style.display = 'none';
    });

    btnProcess.addEventListener('click', async () => {
        const text = receiptText.value.trim();
        const provider = providerSelect.value;

        if (!text) return showError("Si us plau, introdueix el text del tiquet.");

        try {
            setLoading(true);
            
            // Aplicar patró Strategy
            let strategy;
            if (provider === 'gemini') {
                strategy = new GeminiStrategy(GEMINI_KEY);
            } else {
                strategy = new GrokStrategy(GROK_KEY);
            }
            
            aiContext.setStrategy(strategy);
            
            const data = await aiContext.process(text);
            displayResults(data);
            
        } catch (err) {
            showError(err.message);
        } finally {
            setLoading(false);
        }
    });

    function setLoading(isLoading) {
        btnProcess.disabled = isLoading;
        loader.style.display = isLoading ? 'block' : 'none';
        btnText.style.display = isLoading ? 'none' : 'block';
        errorMsg.style.display = 'none';
    }

    function showError(msg) {
        errorMsg.textContent = msg;
        errorMsg.style.display = 'block';
    }

    function displayResults(data) {
        placeholder.style.display = 'none';
        resultsContent.style.display = 'block';
        
        resEstablishment.textContent = data.establishment || 'N/A';
        resDate.textContent = data.date || 'N/A';
        resTotal.textContent = `${parseFloat(data.total || 0).toFixed(2)} €`;
        resCategory.textContent = data.category || 'N/A';
        
        resItems.innerHTML = '<h3>Productes</h3>';
        if (data.items && Array.isArray(data.items)) {
            data.items.forEach(item => {
                const row = document.createElement('div');
                row.className = 'item-row';
                row.innerHTML = `
                    <span>${item.name}</span>
                    <span style="font-weight: 600;">${parseFloat(item.price || 0).toFixed(2)} €</span>
                `;
                resItems.appendChild(row);
            });
        }
    }
});
