class Technology {
    String name;
    int science_req;
    Technology[] prerequisites;

    ArrayList<District_Type> districts_unlocked;
    ArrayList<Building> buildings_unlocked;
    ArrayList<Tile_Improvement> tile_improvements_unlocked;
    ArrayList<Unit> units_unlocked;
}

class Technology_Tree {
    Civilization civ;
    
    Technology researching;
    int science_acc;

    public void on_turn_start() {
        science_acc += civ.turn_stat_gain.stats[3].amount;
        if (science_acc >= researching.science_req)
            on_tech_research_complete();
    }

    private void on_tech_research_complete() {
        // add all unlocks to civ
        // set current tech to researched so it can be checked for prereqs in next techs
    }
}