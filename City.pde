class City {
    String name;
    Civilization civ;
    District city_center;

    ArrayList<Citizen> citizens;
    ArrayList<District> districts;
    ArrayList<Tile> territory;
    
    ArrayList<Product> production_queue;
    
    int city_size;
    int food_acc, production_acc, culture_acc;
    Tile acquire_next;
    Statistics_Block turn_gain;

    public City(String name, Civilization civ, Tile tile) {
        this.name = name;
        this.civ = civ;
        this.city_center = new District(CITY_CENTER, tile);

        citizens = new ArrayList<Citizen>();
        districts = new ArrayList<District>();
        territory = new ArrayList<Tile>();

        init_territory();
    }

    private void init_territory() {
        territory.add(city_center.tile);
        for (Tile t : city_center.tile.neighbours)
            territory.add(t);
    }

    public void on_turn_start() {
        turn_gain = new Statistics_Block();
        turn_gain.add(citizen_gain());
        turn_gain.add(district_gain());
        produce(turn_gain.stats[1].amount);
        grow(turn_gain.stats[0].amount);
        grow_territory(turn_gain.stats[5].amount);
    }

    // for each citizen add worked tiles resources to city/civ
    Statistics_Block citizen_gain() {
        Statistics_Block acc = new Statistics_Block();
        for (Citizen c : citizens)
            acc.add(c.worked.tile_stats);
        // also add bonuses for citizens working in districts (probably by increasing district stats_block for each citizen working there)
        // or using a tile_stats() function instead of fixed variable
        return acc;
    };

    Statistics_Block district_gain() {
        Statistics_Block acc = new Statistics_Block();
        for (District d : districts)
            acc.add(d.district_gain());
        return acc;
    };

    private void grow(int turn_food) {
        //int food_gain = turn_gain.stats[0].amount;
        int food_gain = turn_food;
        food_gain -= 2 * city_size;
        food_acc += food_gain;
        int needed = (city_size + 1) * (city_size + 1);
        if (food_acc >= needed) {
            food_acc -= needed;
            gen_citizen();
        }
    }

    private void produce(int turn_production) {
        production_acc += turn_production;
        if (production_queue.size() == 0) return;
        Product next = production_queue.get(0);
        if (production_acc >= next.production_cost) {
            production_acc -= next.production_cost;
            production_queue.remove(0);
            next.on_production_complete();
        }
    }

    private void grow_territory(int turn_culture) {
        culture_acc += turn_culture;
        // get next tile (acquire_next)
    }

    private void gen_citizen() {

    }

}

class Product {
    int production_cost;

    public void on_production_complete() {}
}

class Unit_Product extends Product {
    Unit unit;
}

class District_Product extends Product {
    District_Type district_type;
    Tile tile;

    public District_Product(District_Type d, Tile t) {
        district_type = d;
        tile = t;
    }

    public void on_production_complete() {
        //tile.district = district;
        new District(district_type, tile);
    }
}

class Building_Product extends Product {
    Building building;
    District district;

    public Building_Product(Building b, District d) {
        building = b;
        district = d;
    }

    public void on_production_complete() {
        district.buildings_built.add(building);
    }
}

class Citizen {
    Tile worked;
}

class District {
    District_Type district_type;
    Tile tile;
    City city;

    ArrayList<Building> buildings_built;

    public District(District_Type district_type, Tile tile) {
        this.district_type = district_type;
        this.tile = tile;
        this.city = tile.city;
    }

    public Statistics_Block district_gain() {
        return district_type.district_gain(this);
    }
}

class Building {
    
}

// __________ DISTRICT TYPES ____________

class District_Type {
    Statistics_Block base_stats;
    ArrayList<Building> district_buildings;

    Statistics_Block district_gain(District d) {
        return null;
        //base + adjacency + buildings + citizens_working
    }
}

class City_Center extends District_Type {}
class Campus extends District_Type {}
class Theater_Square extends District_Type {}
class Holy_Site extends District_Type {}
class Encampment extends District_Type {}
class Commercial_Hub extends District_Type {}
class Harbor extends District_Type {}
class Industrial_Zone extends District_Type {}
class Aqueduct extends District_Type {}
class Neighbourhood extends District_Type {}
class Aerodrome extends District_Type {}

District_Type CITY_CENTER = new City_Center();
District_Type CAMPUS = new Campus();
District_Type THEATER_SQUARE = new Theater_Square();
District_Type HOLY_SITE = new Holy_Site();
District_Type ENCAMPMENT = new Encampment();
District_Type COMMERCIAL_HUB = new Commercial_Hub();
District_Type HARBOR = new Harbor();
District_Type INDUSTRIAL_ZONE = new Industrial_Zone();
District_Type AQUEDUCT = new Aqueduct();
District_Type NEIGHBOURHOOD = new Neighbourhood();
District_Type AERODROME = new Aerodrome();