# 🤖 Agent IA Multimodal

**Agent IA Multimodal** est une application mobile Flutter connectée à un serveur backend Spring Boot qui permet :
- d’envoyer des requêtes textuelles à une IA,
- de poser des questions basées sur des images,
- de générer des images à partir d’un prompt.

---

## 📸 Aperçu de l'application

> ⚠️ Remplace les images suivantes par des captures d'écran de ton app :

| Écran de chat | Génération d'image | Upload d'image |
|---------------|---------------------|----------------|
| ![chat_screen](screenshots/chat_screen.png) | ![generate_image](screenshots/generate_image.png) | ![upload_image](screenshots/upload_image.png) |

---

## 🧱 Architecture du projet

### Backend :
 J'ai utilise l application Spring boot ai-agents-spirng-ai (https://github.com/HamzaRabih/ai-agents-spirng-ai.git)

### 📁 (frontend) Structure Flutter 

```bash
lib/
├── main.dart               # Entrée principale
├── screens/
│   └── chat_screen.dart    # UI principale
├── services/
│   └── api_service.dart    # Communication avec le backend
├── widgets/
│   └── message_bubble.dart # Affichage des messages
```
## 🚀 Lancer le projet

### 🔧 Backend (Spring Boot)

Clone le backend :

```bash
    git clone https://github.com/HamzaRabih/ai-agents-spirng-ai.git
```
 Configure le port 8899 si besoin dans application.properties.

 Lance l'application :
```bash
./mvnw spring-boot:run
Le serveur sera disponible sur http://localhost:8899
```
## 📱 Frontend (Flutter)

Clone ce projet Flutter :

```bash
git clone https://github.com/HamzaRabih/ai_flutter_client.git
```
Installe les dépendances :

```bash
    flutter pub get
```
Lance sur un simulateur ou un appareil :

```bash
flutter run
```
Assure-toi que l'adresse IP du backend dans api_service.dart (_baseUrl) est correcte et accessible depuis ton appareil.

### 🧠 Fonctionnalités

| Fonction                       | Description | 
|--------------------------------|---------------------|
| 💬 Chat texte | Pose une question en texte libre, l’IA répond. | 
| 💬 🖼️ Génération d’image | Génère une image à partir d’un prompt textuel. | 
| 📷 Question sur image | Pose une question à partir d’une image uploadée. | 

