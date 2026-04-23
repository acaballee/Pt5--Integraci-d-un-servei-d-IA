# PT5 - Integració d'un servei IA

## Alumne: Alex Caballé Arasa
## Projecte: SmartReceipt AI

Aquesta vàlua correspon a la PT5 de l'assignatura d'Ampliació de DAM. S'ha desenvolupat la integració de IA pel projecte d'assistent financer (PT4) aplicant el patró de disseny **Strategy**.

### 1. Aplicació del Patró Strategy

El patró Strategy s'ha utilitzat per permetre que l'aplicació pugui canviar entre diferents proveïdors de models de llenguatge (LLM) de forma dinàmica sense afectar la lògica de negoci.

#### Estructura de classes:
- **`AIStrategy` (Interfície/Base)**: Defineix el contracte que totes les estratègies han de complir (`processReceipt`) i conté la definició del prompt comú per garantir la consistència.
- **`GeminiStrategy`**: Implementa la comunicació amb l'API de Google Gemini (model Flash 1.5).
- **`GroqStrategy`**: Implementa la comunicació amb l'API de Groq (model Llama 3).
- **`AIContext`**: Actua com a gestor. Rep una estratègia i l'executa quan l'usuari demana processar un tiquet.

### 2. Gestió de Prompts i JSON

S'ha dissenyat un prompt optimitzat que obliga a la IA a retornar estrictament un objecte JSON amb els camps:
- `establishment`
- `date`
- `total`
- `category`
- `items` (llista de productes i preus)

L'aplicació parseja aquesta resposta i la mostra de forma visual en una graella de dades i una llista de productes, evitant mostrar codi en brut a l'usuari final.

### 3. Interfície d'Usuari

S'ha creat una interfície web "premium" seguint les millors pràctiques de disseny:
- **Dark Mode**: Per reduir la fatiga visual.
- **Glassmorphism**: Efectes de transparència i profunditat.
- **Responsive**: Adaptable a dispositius mòbils (context d'ús original de la PT4).
- **Feedback**: Estats de càrrega i gestió d'errors clara.

### 4. Com executar

1. Obre `index.html` en un navegador (preferiblement via Live Server).
2. Selecciona el proveïdor (Gemini o Groq).
3. Introdueix la teva API Key.
4. Enganxa el text d'un tiquet o descriu una compra.
5. Prem "Processar amb IA".
