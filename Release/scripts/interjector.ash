script "interjector.ash"

void main(string arguments) 
{
    // variables
    // TODO: save as outfit?
    item current_hat = equipped_item($slot[hat]);
    item current_shirt = equipped_item($slot[shirt]);
    item current_back = equipped_item($slot[back]);
    item current_pants = equipped_item($slot[pants]);
    item current_weapon = equipped_item($slot[weapon]);
    item current_offhand = equipped_item($slot[off-hand]);
    item current_acc1 = equipped_item($slot[acc1]);
    item current_acc2 = equipped_item($slot[acc2]);
    item current_acc3 = equipped_item($slot[acc3]);
    item current_fam_equipment = equipped_item($slot[familiar]);

    familiar current_familiar = my_familiar();

    // TODO add way to check if oasis is unlocked?
    string autumn_maton_location = "Oil Peak"; // try hunting for oil
    // string autumn_maton_location = "Shadow Rift";

    location current_location = my_location();

    boolean[string] toggles;
    toggles["digitize"] = true;
    toggles["sausage"] = true;
    toggles["robot"] = true;
    toggles["animal"] = true;

    if (arguments.contains_text("nofam")) {
        toggles["animal"] = false;
    }


    boolean digitizeMonster() 
    {
        if (get_counter("Digitize Monster").to_int() == 0) 
        {
            // Step one: maximize meat gain
            // meat familiar
            cli_execute("familiar Jill-of-All-Trades");

            // meat outfit
            outfit("Script Outfit 5"); // the outfit garbo seems to use for digitized monsters
            if (get_property("parkaMode") != "kachungasaur")
            {
                cli_execute("parka kachungasaur");
            }

            // meat mood
            cli_execute("mood meatfarm");

            // changed ccs
            set_ccs("digitized cockroach");

            // Step two: use purple copy if available, fight@
            if (have_effect($effect[Everything Looks Purple]) == 0)
            {
                equip($slot[off-hand], $item[Roman Candelabra]);
                set_location($location[Noob Cave]);
                run_combat();
                run_combat();
            } else
            {
                adv1($location[Noob Cave],-1,"");
            }


            // Step three: return character to previous state
            set_location(current_location); // resets the location to the previous location

            // reequip all items, again can maybe be made into an outfit instead
            equip($slot[hat], current_hat);
            equip($slot[shirt], current_shirt);
            equip($slot[back], current_back);
            equip($slot[pants], current_pants);
            equip($slot[weapon], current_weapon);
            equip($slot[off-hand], current_offhand);
            equip($slot[acc1], current_acc1);
            equip($slot[acc2], current_acc2);
            equip($slot[acc3], current_acc3);
            cli_execute("familiar " + current_familiar);
            cli_execute("mood apathetic"); // reset mood
            set_property("_ccs_changed", true);
            return true;
        }
        else 
        {
            return false;
        }
    }

    boolean sausageGobbler() 
    {
        string goblinsFought = get_property("_sausageFights");
        string lastSausageMonster = get_property("_lastSausageMonsterTurn");
        int turnsSinceLastGoblin = total_turns_played() - to_int(lastSausageMonster);
        int nextGuaranteedGoblin = 4 + to_int(goblinsFought) * 3 + MAX(0, to_int(goblinsFought) - 5) * MAX(0, to_int(goblinsFought) - 5) * MAX(0, to_int(goblinsFought) - 5);
        int turnsToNextGuaranteedFight = MAX(0, nextGuaranteedGoblin - turnsSinceLastGoblin);
        if (goblinsFought == 0) 
        {
            turnsToNextGuaranteedFight = 0;
        }

        float clampf(float v, float min_value, float max_value)
        {
            if (v > max_value)
                return max_value;
            if (v < min_value)
                return min_value;
            return v;
        }

        int goblinMultiplier = MAX(0, to_int(goblinsFought) - 5);
        float probabilityOfFight = to_float(turnsSinceLastGoblin + 1) / (5.0 + to_float(goblinsFought) * 3.0 + to_float(goblinMultiplier) * to_float(goblinMultiplier) * to_float(goblinMultiplier));
        print((turnsToNextGuaranteedFight == 0));

        if (turnsToNextGuaranteedFight == 0)
        {
            set_ccs("dumpturns"); // ccs used with Kramco
            equip($slot[off-hand], $item[Kramco Sausage-o-Matic&trade;]); // equips Kramco
            adv1($location[Noob Cave],-1,""); // adventures once in noob cave
            set_location(current_location); // resets the location to the previous location
            equip($slot[off-hand], current_offhand); // resets the offhand to the previous offhand
            set_property("_ccs_changed", true);
            return true;
        } else 
        {
            return false;
        }
    }

    void sendRobot() 
    {
        if (item_amount($item[Autumn-aton]).to_boolean())
        {
            print("Sending your autumn-aton!", "green");
            cli_execute("autumnaton send " + autumn_maton_location);
        }
    }

    void handleAnimal()
    {
        if (
            (get_property("_aguaDrops").to_int() < 5) &&
            (my_familiar() != $familiar[Baby Sandworm])
            )
        {
            use_familiar($familiar[Baby Sandworm]);
            equip($slot[familiar], current_fam_equipment);
            return;
        }
        else if (
            (get_property("_knuckleboneDrops").to_int() < 100) &&
            (my_familiar() != $familiar[Skeleton of Crimbo Past])
            )
        {
            use_familiar($familiar[Skeleton of Crimbo Past]);
            equip($slot[familiar], current_fam_equipment);
            return;
        }
        else if (
            (get_property("_aguaDrops").to_int() == 5) &&
            (get_property("_knuckleboneDrops").to_int() > 99)
            )
        {
            use_familiar($familiar[Cookbookbat]);
            equip($slot[familiar], $item[tiny stillsuit]);
            return;
        }


    sendRobot();

    if (toggles["animal"] == true) 
    {
        // check if we are on our last fam somehow?
        handleAnimal();
    }

    if (digitizeMonster() == true) 
    {
        print("We digitized a monster", "green");
    }

    if (sausageGobbler() == true) 
    {
        print("We gobbled a sausage", "green");
    }
}
