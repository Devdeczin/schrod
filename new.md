# NEW.md | Version: BEH! - Gen 4 Ver 1.1
(made with google gemini)

## 📁 System Architecture

* **Structured Module Organization (`/modules`):**
* `/drivers`: Low-level access to hardware components (VGA, Keyboard, PIC).
* `/actions`: Core kernel actions and UI dispatching.
* `/arch`: Architecture-specific implementations (GDT, IDT, IO).
* `/lang`: Language helpers and "Pythonfy" facilitators to streamline Nim development.
* `/misc`: Utilities and miscellaneous functions.

## 🎨 Smart Theme System (New!)

* **Context-Aware Remapping:** The kernel no longer just "paints" the screen one color. It now remembers the "intent" of the text (Warnings, Success, Errors) and translates those specific colors when switching themes.
* **Dynamic Theme Toggle:** Support for multiple palettes (e.g., *ClassicJazz* and *QuarkCat*).
* **Persistence:** Your kernel logs stay readable and correctly categorized even after a theme change.

## ⌨️ Input & Keyboard Driver

* **Hardware Interrupts:** Fully mapped IDT (Interrupt Descriptor Table) and GDT (Global Descriptor Table) to handle IRQs.
* **RSPD (Rapid Scancode Processing Daemon):** Improved logic to handle modifier keys (Shift/Ctrl).
* **Hotkey Support:** * `Ctrl + T`: Cycles through available themes instantly.
* **Scancode Mapping:** Support for US-International layouts via `keymapLower` and `keymapUpper`.

## ⚙️ Kernel Core & Events

* **KernelEvent System:** Added `KernelEvent` enum for internal state tracking (e.g., `kNextTheme`).
* **Timer Support:** Basic timer implementation via PIT.
* **Pythonfy Facilitators:** Added high-level templates (`ksprint`, `kbprint`) and `ttyPutChar` for easier text manipulation without sacrificing "bare metal" performance.

## 🚀 Automation

* **`commands.sh`:** Full automation for the compilation and linking process (LINUX ONLY).