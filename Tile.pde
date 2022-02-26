class Tile {
    int[] tile_pos;
    float[] world_pos;
    Tile[] neighbours;
    Map map;

    Base_Terrain base_terrain;
    Terrain_Feature terrain_feature;
    Resource resource;
    int temp, precip, height;
    color tile_col;
    
    Yield_Block tile_stats;
    
    City city; // owner
    District district;
    Tile_Improvement tile_improvement;

    Combat_Unit_Entity combat_unit;
    Utility_Unit_Entity utility_unit;
    Religion_Unit_Entity religion_unit;
    ArrayList<Trader_Unit_Entity> trader_units;

    public Tile(int[] pos, Map map) {
        this.tile_pos = pos;
        this.world_pos = new float[] {tile_pos[0] * x_tile_dis + (pos[1] % 2 == 1 ? x_tile_dis / 2 : 0), tile_pos[1] * y_tile_dis};
        this.map = map;
        this.neighbours = new Tile[6];

        trader_units = new ArrayList<Trader_Unit_Entity>();
    }

    public Tile(int[] pos, Map map, Base_Terrain bt, Terrain_Feature tf) {
        this.tile_pos = pos;
        this.world_pos = new float[] {tile_pos[0] * x_tile_dis + (pos[1] % 2 == 1 ? x_tile_dis / 2 : 0), tile_pos[1] * y_tile_dis};
        this.map = map;
        this.neighbours = new Tile[6];
        this.base_terrain = bt;
        this.terrain_feature = tf;

        trader_units = new ArrayList<Trader_Unit_Entity>();
    }

    private void set_tile_pair_neighbours(Tile t, int i) {
        neighbours[i] = t;
        t.neighbours[(i + 3) % 6] = this;
    }

    private void init_neighbours() {
        // example of config (xy)
        // neighbour index starts at upper left
        //  10  20  30  40
        //    11  21  31
        //      22  32
        neighbours = new Tile[6];
        int[] p = tile_pos;
        int mw = map.map_width;
        if (p[1] != 0) {
            set_tile_pair_neighbours(map.tiles[p[0]][p[1]-1], p[1] % 2 == 0 ? 1 : 0);
            if (p[1] % 2 == 1)
                set_tile_pair_neighbours(map.tiles[(p[0]+1)%mw][p[1]-1], 1);
            if (p[1] % 2 == 0)
                set_tile_pair_neighbours(map.tiles[(p[0]-1+mw)%mw][p[1]-1], 0);
        }
        // else neighbours[0] = neighbours[1] = void_tile; // tile for edge of world
        set_tile_pair_neighbours(map.tiles[(p[0]-1+mw)%mw][p[1]], 5);
    }

    public void draw_tile(float x, float y) {
        float rx = world_pos[0] - x;
        float ry = world_pos[1] - y;
        if (rx < -map.map_width_f / 2) rx += map.map_width_f;
        base_terrain.render(rx, ry);
        // terrain_feature.render();
        // render district on tile | district.draw_district();
        // render units on tile | combat_unit.draw_unit();
    }

    public int move_penalty() {
        return 1;
    }

}

final int SERIAL_SELECT_BASE_TERRAIN = 0xff;
final int SERIAL_SELECT_TERRAIN_FEATURE = 0xff00;

class Base_Terrain {
    String name;
    Yield_Block base_stats;
    int move_penalty;
    int defense_bonus;

    boolean workable = true, passable = true;

    Tile_Improvement[] improvements;
    Terrain_Feature[] possible_features;
    Resource[] possible_resources;

    PImage original, resized;

    public Base_Terrain(String name, Yield_Block s, int mp, int db, Tile_Improvement[] ti, Terrain_Feature[] tf, Resource[] r, PImage sprite) {
        this.name = name;
        this.base_stats = s;
        this.move_penalty = mp;
        this.defense_bonus = db;
        this.improvements = ti;
        this.possible_features = tf;
        this.possible_resources = r;
        this.original = sprite;
        this.resized = original.copy();
        resized.resize(0, (int)(2*tile_half_diag_len)+6);
    }

    public void render(float x, float y) {
        image(resized, x, y);
    }
}

class Terrain_Feature {
    Yield_Block bonus_stat;
    int move_penalty;
    int defense_bonus;
    // possibly add appeal

    Tile_Improvement[] improvements;

    public Terrain_Feature(Yield_Block s, int mp, int db, Tile_Improvement[] ti) {
        this.bonus_stat = s;
        this.move_penalty = mp;
        this.defense_bonus = db;
        this.improvements = ti;
    }
}

class Tile_Improvement {
    Yield_Block improvement;
    Resource improved; // add this resource's yield to tile stats
    //Bonus or Luxury resource acquired

}

Base_Terrain grassland, plains, desert, tundra, snow;
Base_Terrain grassland_hills, plains_hills, desert_hills, tundra_hills, snow_hills;
Base_Terrain grassland_mountains, plains_mountains, desert_mountains, tundra_mountains, snow_mountains;
Base_Terrain coast, ocean;

java.util.Map BASE_TERRAINS = new HashMap<Integer, Base_Terrain>();
private void load_base_terrains() {
    grassland = new Base_Terrain("Grassland", new Yield_Block(new int[] {2, 0, 0, 0, 0, 0}), 1, 0, null, null, null, loadImage("sprites/base_terrain/grassland.png"));
    plains = new Base_Terrain("Plains", new Yield_Block(new int[] {1, 1, 0, 0, 0, 0}), 1, 0, null, null, null, loadImage("sprites/base_terrain/plains.png"));
    desert = new Base_Terrain("Desert", new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 1, 0, null, null, null, loadImage("sprites/base_terrain/desert.png"));
    tundra = new Base_Terrain("Tundra", new Yield_Block(new int[] {1, 0, 0, 0, 0, 0}), 1, 0, null, null, null, loadImage("sprites/base_terrain/tundra.png"));
    snow = new Base_Terrain("Snow", new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 1, 0, null, null, null, loadImage("sprites/base_terrain/snow.png"));

    grassland_hills = new Base_Terrain("Grassland (Hills)", new Yield_Block(new int[] {2, 1, 0, 0, 0, 0}), 2, 0, null, null, null, loadImage("sprites/base_terrain/grassland_hills.png"));
    plains_hills = new Base_Terrain("Plains (Hills)", new Yield_Block(new int[] {1, 2, 0, 0, 0, 0}), 2, 0, null, null, null, loadImage("sprites/base_terrain/plains_hills.png"));
    desert_hills = new Base_Terrain("Desert (Hills)", new Yield_Block(new int[] {0, 1, 0, 0, 0, 0}), 2, 0, null, null, null, loadImage("sprites/base_terrain/desert_hills.png"));
    tundra_hills = new Base_Terrain("Tundra (Hills)", new Yield_Block(new int[] {1, 1, 0, 0, 0, 0}), 2, 0, null, null, null, loadImage("sprites/base_terrain/tundra_hills.png"));
    snow_hills = new Base_Terrain("Snow (Hills)", new Yield_Block(new int[] {0, 1, 0, 0, 0, 0}), 2, 0, null, null, null, loadImage("sprites/base_terrain/snow_hills.png"));

    grassland_mountains = new Base_Terrain("Grassland (Mountains)", new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, loadImage("sprites/base_terrain/grassland_mountains.png"));
    plains_mountains = new Base_Terrain("Plains (Mountains)", new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, loadImage("sprites/base_terrain/plains_mountains.png"));
    desert_mountains = new Base_Terrain("Desert (Mountains)", new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, loadImage("sprites/base_terrain/desert_mountains.png"));
    tundra_mountains = new Base_Terrain("Tundra (Mountains)", new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, loadImage("sprites/base_terrain/tundra_mountains.png"));
    snow_mountains = new Base_Terrain("Snow (Mountains)", new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, loadImage("sprites/base_terrain/snow_mountains.png"));
    grassland_mountains.workable = grassland_mountains.passable = false;
    plains_mountains.workable = plains_mountains.passable = false;
    desert_mountains.workable = desert_mountains.passable = false;
    tundra_mountains.workable = tundra_mountains.passable = false;
    snow_mountains.workable = snow_mountains.passable = false;

    coast = new Base_Terrain("Coast", new Yield_Block(new int[] {1, 0, 1, 0, 0, 0}), 1, 0, null, null, null, loadImage("sprites/base_terrain/coast.png"));
    // Base_Terrain lake = new Base_Terrain("Lake", new Yield_Block(new int[] {1, 0, 1, 0, 0, 0}), 1, 0, null, null, null, 0x70);
    ocean = new Base_Terrain("Ocean", new Yield_Block(new int[] {1, 0, 0, 0, 0, 0}), 1, 0, null, null, null, loadImage("sprites/base_terrain/ocean.png"));

    BASE_TERRAINS.put(0x00, ocean);
    BASE_TERRAINS.put(0x01, ocean);
    BASE_TERRAINS.put(0x02, ocean);
    BASE_TERRAINS.put(0x03, ocean);
    BASE_TERRAINS.put(0x04, ocean);
    BASE_TERRAINS.put(0x10, coast);
    BASE_TERRAINS.put(0x11, coast);
    BASE_TERRAINS.put(0x12, coast);
    BASE_TERRAINS.put(0x13, coast);
    BASE_TERRAINS.put(0x14, coast);
    BASE_TERRAINS.put(0x20, grassland);
    BASE_TERRAINS.put(0x21, plains);
    BASE_TERRAINS.put(0x22, desert);
    BASE_TERRAINS.put(0x23, tundra);
    BASE_TERRAINS.put(0x24, snow);
    BASE_TERRAINS.put(0x30, grassland_hills);
    BASE_TERRAINS.put(0x31, plains_hills);
    BASE_TERRAINS.put(0x32, desert_hills);
    BASE_TERRAINS.put(0x33, tundra_hills);
    BASE_TERRAINS.put(0x34, snow_hills);
    BASE_TERRAINS.put(0x40, grassland_mountains);
    BASE_TERRAINS.put(0x41, plains_hills);
    BASE_TERRAINS.put(0x42, desert_mountains);
    BASE_TERRAINS.put(0x43, tundra_mountains);
    BASE_TERRAINS.put(0x44, snow_mountains);
}