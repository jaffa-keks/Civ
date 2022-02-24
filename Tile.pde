class Tile {
    int[] tile_pos;
    float[] world_pos;
    Tile[] neighbours;
    Map map;

    Base_Terrain base_terrain;
    Terrain_Feature terrain_feature;
    Resource resource;
    
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
        //float rx = (world_pos[0] - x + map.map_width_f) % map.map_width_f;
        float rx = world_pos[0] - x;
        float ry = world_pos[1] - y;
        if (rx < -map.map_width_f / 2) rx += map.map_width_f;
        // if (tile_sprite == null) {
        if (true) {
            stroke(0);
            // fill(tile_col);
            fill(0xff00ffcc);
            beginShape();
            for (float[] p : tile_rel_points)
                vertex(rx + p[0], ry + p[1]);
            endShape(CLOSE);
            fill(0);
            textAlign(CENTER);
            text(tile_pos[0] + ", " + tile_pos[1], rx, ry);
        } else {
            //imageMode(CENTER);
            //image(tile_sprite, world_pos[0], world_pos[1]);
        }
        // render units on tile | combat_unit.draw_unit();
        // render district on tile | district.draw_district();
    }

    public int move_penalty() {
        return 1;
    }

}

class Base_Terrain {
    Yield_Block base_stats;
    int move_penalty;
    int defense_bonus;

    boolean workable = true, passable = true;

    Tile_Improvement[] improvements;
    Terrain_Feature[] possible_features;
    Resource[] possible_resources;

    final int SERIAL_SELECT = 0x11;
    final int SERIAL_ID;

    public Base_Terrain(Yield_Block s, int mp, int db, Tile_Improvement[] ti, Terrain_Feature[] tf, Resource[] r, int SERIAL_ID) {
        this.base_stats = s;
        this.move_penalty = mp;
        this.defense_bonus = db;
        this.improvements = ti;
        this.possible_features = tf;
        this.possible_resources = r;
        this.SERIAL_ID = SERIAL_ID;
    }
}

class Terrain_Feature {
    Yield_Block bonus_stat;
    int move_penalty;
    int defense_bonus;
    // possibly add appeal

    Tile_Improvement[] improvements;

    final int SERIAL_SELECT = 0x1100;
    final int SERIAL_ID;

    public Terrain_Feature(Yield_Block s, int mp, int db, Tile_Improvement[] ti, int SERIAL_ID) {
        this.bonus_stat = s;
        this.move_penalty = mp;
        this.defense_bonus = db;
        this.improvements = ti;
        this.SERIAL_ID = SERIAL_ID;
    }
}

class Tile_Improvement {
    Yield_Block improvement;
    Resource improved; // add this resource's yield to tile stats
    //Bonus or Luxury resource acquired

}

// add sprite (pimage) to constructor and to each below

Base_Terrain grassland = new Base_Terrain(new Yield_Block(new int[] {2, 0, 0, 0, 0, 0}), 1, 0, null, null, null, 0x10);
Base_Terrain plains = new Base_Terrain(new Yield_Block(new int[] {1, 1, 0, 0, 0, 0}), 1, 0, null, null, null, 0x20);
Base_Terrain dessert = new Base_Terrain(new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 1, 0, null, null, null, 0x30);
Base_Terrain tundra = new Base_Terrain(new Yield_Block(new int[] {1, 0, 0, 0, 0, 0}), 1, 0, null, null, null, 0x40);
Base_Terrain snow = new Base_Terrain(new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 1, 0, null, null, null, 0x50);

Base_Terrain grassland_hills = new Base_Terrain(new Yield_Block(new int[] {2, 1, 0, 0, 0, 0}), 2, 0, null, null, null, 0x11);
Base_Terrain plains_hills = new Base_Terrain(new Yield_Block(new int[] {1, 2, 0, 0, 0, 0}), 2, 0, null, null, null, 0x21);
Base_Terrain dessert_hills = new Base_Terrain(new Yield_Block(new int[] {0, 1, 0, 0, 0, 0}), 2, 0, null, null, null, 0x31);
Base_Terrain tundra_hills = new Base_Terrain(new Yield_Block(new int[] {1, 1, 0, 0, 0, 0}), 2, 0, null, null, null, 0x41);
Base_Terrain snow_hills = new Base_Terrain(new Yield_Block(new int[] {0, 1, 0, 0, 0, 0}), 2, 0, null, null, null, 0x51);

Base_Terrain grassland_mountains = new Base_Terrain(new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, 0x12);
Base_Terrain plains_mountains = new Base_Terrain(new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, 0x22);
Base_Terrain dessert_mountains = new Base_Terrain(new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, 0x32);
Base_Terrain tundra_mountains = new Base_Terrain(new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, 0x42);
Base_Terrain snow_mountains = new Base_Terrain(new Yield_Block(new int[] {0, 0, 0, 0, 0, 0}), 0, 0, null, null, null, 0x52);
// grassland_mountains.workable = grassland_mountains.passable = false;
// plains_mountains.workable = plains_mountains.passable = false;
// dessert_mountains.workable = dessert_mountains.passable = false;
// tundra_mountains.workable = tundra_mountains.passable = false;
// snow_mountains.workable = snow_mountains.passable = false;

Base_Terrain coast = new Base_Terrain(new Yield_Block(new int[] {1, 0, 1, 0, 0, 0}), 1, 0, null, null, null, 0x60);
Base_Terrain lake = new Base_Terrain(new Yield_Block(new int[] {1, 0, 1, 0, 0, 0}), 1, 0, null, null, null, 0x70);
Base_Terrain ocean = new Base_Terrain(new Yield_Block(new int[] {1, 0, 0, 0, 0, 0}), 1, 0, null, null, null, 0x80);
// ocean.workable = false;