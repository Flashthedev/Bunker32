# Interaction System
This system massively sets up proximity prompts and is very modular

# Setup
Place all things that are in the Client folder inside starter player scripts (that creates a custom prompt which you can modify using the Prompt module)
All the other things must be placed inside ServerScriptService, Interactions go on a folder that must be named Interaction **inside the helper module**
All interactable things must be tagged with a collection service tag names Interactable
To configure interaction aspects, attributes are used. The available attributes are:
    - Clearance<string>
    - Clearance Alternative<String> (Toggled by ClearanceToggle)
    - ClearanceToggle<bool>
    - Cooldown<number> (Time the prompt is disabled for after use)
    - Description<string> (Used to set the proximity prompt description)
    - Distance<number> (The distance the prompt can be used from)
    - Event<string[EventModuleName]> (The event to execute on interaction)
    - HoldDuration<number> (The duration you need to hold the prompt for)
    - Keycode<KeyName[A-Z]> (The key needed to be pressed to interact)
