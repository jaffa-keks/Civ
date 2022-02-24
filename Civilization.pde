// ADD LEADER AND BONUSES PER CIV AND LEADER

class Civilization {
    String name;
    City capital;

    ArrayList<City> cities;
    ArrayList<Unit_Entity> units;

    Yield_Block civilization_stats, turn_stat_gain;
    java.util.Map<Strategic_Resource, Integer> strategic_resources;
    java.util.Map<Luxury_Resource, Integer> luxury_resources;
    Technology_Tree tech_tree;

    ArrayList<District_Type> districts_unlocked;
    ArrayList<Building> buildings_unlocked;
    ArrayList<Tile_Improvement> tile_improvements_unlocked;
    ArrayList<Unit> units_unlocked;

    public Civilization(String name) {
        this.name = name;

        cities = new ArrayList<City>();
        units = new ArrayList<Unit_Entity>();

        civilization_stats = new Yield_Block();
        strategic_resources = new HashMap<Strategic_Resource, Integer>();
        luxury_resources = new HashMap<Luxury_Resource, Integer>();
        tech_tree = new Technology_Tree();

        districts_unlocked = new ArrayList<District_Type>();
        buildings_unlocked = new ArrayList<Building>();
        tile_improvements_unlocked = new ArrayList<Tile_Improvement>();
        units_unlocked = new ArrayList<Unit>();
    }

    public void on_turn_start() {
        turn_stat_gain = new Yield_Block();

        for (City c : cities) {
            c.on_turn_start();
            civilization_stats.add(c.turn_gain);
            turn_stat_gain.add(c.turn_gain);
        }
        for (Unit_Entity u : units)
            u.on_turn_start();

        tech_tree.on_turn_start();
    }
}

class Leader {

}