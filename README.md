# Ultimate Controller Support 🎮  
A mod designed to enhance and expand controller support for the 2006 PC version of *Marvel: Ultimate Alliance*.

## 📥 Download the Latest Release  
Get the newest version of the mod [here](https://github.com/JordanLeich/Ultimate-Controller-Support/releases).  

---

## ⚡ Easy Installation  
1. **Extract** the **Ultimate Controller Support** `.rar` file to any location.  
2. **Run** `Easy Install.bat` and follow the on-screen prompts based on your controller type.  

💡 **Tip:** If your button textures appear incorrect after using Easy Install, try selecting the *opposite* answer to the “What controller type are you using?” question. This fixes the issue for many users.

---

## 🧩 Mod Organizer 2 (MO2) Installation  
1. **Extract** the `.rar` file to any location.  
2. **Run** `Easy Install.bat` and follow the prompts. You can paste a MO2 mod folder when installing textures.  
3. Navigate to the **Mod Organizer 2 Install Method** folder and locate the `.rar` file for your specific controller textures. **Install** this file into MO2.  

> **Note:** If Easy Install completes successfully, this step is optional.  

---

## ⚠️ Important Notes & Troubleshooting  
Ultimate Controller Support (UCS) enhances controller textures and configurations, but **it does not guarantee plug-and-play controller recognition**. The game itself must already recognize your controller. UCS only modifies textures and configuration files—it does **not** handle:  
- Bluetooth connectivity  
- Drivers or third-party controller tools  
- Steam Controller configurations  

### Before You Start  
- **Controller Recognition:** Your controller must already work in-game before UCS can apply textures. Prior to starting the game, check if your controller is recognized [here](https://hardwaretester.com/gamepad).
- **Co-op Play:** All players should connect their controllers and select them in-game (or from a previous session) *before* running `Easy Install.bat`.  
- **Configuration Settings:**  
  - Switch to **Manual** in the MUA options if Automatic doesn’t work.  
  - Use **Automatic** if you’re using a standard Xbox 360 layout or if Manual fails.  
- **Low Resolutions:** 640×480 and 800×600 are not fully supported.  
- **Language Support:** To use other languages (e.g., Italian), edit `Easy Install.bat` and change the `lang=eng` setting at the top.  
- **Windows Protected Folders:** Easy Install cannot run from protected windows directories such as:  
C:\Program Files
C:\Program Files (x86)
C:\Windows
C:\Users<YourUsername>\AppData
C:\ProgramData

- **Environment Variables:** If Easy Install won’t open, run `Add required system environment variables.bat` (found in the `tools` folder), then retry Easy Install.

### Getting Controller Icons to Work  
If your controller icons still don’t display correctly, it’s up to **you** to troubleshoot drivers, Steam configs, or third-party tools. UCS can assist by providing texture files, but **you may need to adjust Steam controller settings, update drivers, or use other utilities** to achieve proper icon display.  

---

## ❤️ Credits  
* **Rampage** – Mod creation  
* **Crescendo** – Testing  
* **ak2yny** – Bug finding, testing, batch tool  
* **BaconWizard17** – Xbox One textures preset  
* [ImageMagick](https://github.com/ImageMagick/ImageMagick) – `convert.exe` utility  
