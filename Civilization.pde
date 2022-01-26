// ADD LEADER AND BONUSES PER CIV AND LEADER

class Civilization {
    String name;
    City capital;

    ArrayList<City> cities;
    ArrayList<Unit_Entity> units;

    Statistics_Block civilization_statistics, turn_stat_gain;
    Technology_Tree tech_tree;

    ArrayList<District_Type> districts_unlocked;
    ArrayList<Building> buildings_unlocked;
    ArrayList<Tile_Improvement> tile_improvements_unlocked;
    ArrayList<Unit> units_unlocked;

    public Civilization(String name) {
        this.name = name;

        cities = new ArrayList<City>();
        units = new ArrayList<Unit_Entity>();

        civilization_statistics = new Statistics_Block();
        tech_tree = new Technology_Tree();

        districts_unlocked = new ArrayList<District_Type>();
        buildings_unlocked = new ArrayList<Building>();
        tile_improvements_unlocked = new ArrayList<Tile_Improvement>();
        units_unlocked = new ArrayList<Unit>();
    }

    public void on_turn_start() {
        turn_stat_gain = new Statistics_Block();

        for (City c : cities) {
            c.on_turn_start();
            civilization_statistics.add(c.turn_gain);
            turn_stat_gain.add(c.turn_gain);
        }
        for (Unit_Entity u : units)
            u.on_turn_start();

        tech_tree.on_turn_start();
    }
}

class Leader {

}