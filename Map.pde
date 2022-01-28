float tile_half_diag_len = 48;
float sqrt3 = sqrt(3);
float sqrt3over2 = sqrt(3) / 2;
float x_tile_dis = tile_half_diag_len * sqrt3;
float y_tile_dis = tile_half_diag_len * 3 / 2;

int screen_width_tiles;
int screen_height_tiles;

float[][] tile_rel_points = calc_tile_points();
float[][] calc_tile_points() {
    float[][] r = new float[6][2];
    for (int i = 0; i < 6; i++) {
        r[i][0] = tile_half_diag_len*cos(PI/6 + i * PI/3);
        r[i][1] = tile_half_diag_len*sin(PI/6 + i * PI/3);
    }
    return r;
}

class Map {
    int map_width, map_height;
    float map_width_f, map_height_f;
    Tile[][] tiles;

    int player_num;
    Civilization[] civs;

    int turn;

    public Map(int w, int h, Civilization[] civs) {
        this.map_width = w;
        this.map_height = h;
        this.map_width_f = w * x_tile_dis;
        this.map_height_f = h * y_tile_dis;
        tiles = new Tile[map_width][map_height];
        map_gen();

        this.civs = civs;
        player_num = civs.length;
        init_capitals();
    }

    private void map_gen() {
        // replace this sometime with good world generator
        for (int y = 0; y < map_height; y++) {
            for (int x = 0; x < map_width; x++) {
                tiles[x][y] = new Tile(new int[] {x, y}, this);
            }
        }
        for (int y = 0; y < map_height; y++) {
            for (int x = 0; x < map_width; x++) {
                tiles[x][y].init_neighbours();
            }
        }
    }

    private void init_capitals() {
        for (int i = 0; i < player_num; i++)
            civs[i].capital = new City("REPLACE_WITH_NATION_CAPITAL_NAME", civs[i], capital_tile_gen(i));
    }

    Tile capital_tile_gen(int i) {
        // for now
        int kx = map_width / player_num;
        int ky = map_height / player_num;
        return tiles[2 + kx * i][2 + ky * i];
    }

    public void next_turn() {
        turn++;
        // if not simultanious for all civs, first start for the simultanious ones and first of those which are not and then for every nonsim
        for (Civilization c : civs)
            c.on_turn_start();
    }

    public void draw_map(float x_off, float y_off) {
        int x_start = (int)(x_off / x_tile_dis);
        int y_start = (int)(y_off / y_tile_dis);
        int y_max = min(screen_height_tiles, map_height - y_start);
        for (int x = 0; x < screen_width_tiles; x++) {
            for (int y = 0; y < y_max; y++) {
                tiles[(x_start + x) % map_width][y_start + y].draw_tile(x_off, y_off);
            }
        }
    }
}

class Tile {
    int[] tile_pos;
    float[] world_pos;
    Tile[] neighbours;
    Map map;

    int tile_col = 0xff00cccc;
    PImage tile_sprite;
    
    int move_penalty; // increased by type of terrain, decreased by road
    Statistics_Block tile_stats;
    
    City city;
    District district;
    Tile_Improvement tile_improvement;

    Combat_Unit_Entity combat_unit;
    Utility_Unit_Entity utility_unit;
    Religion_Unit_Entity religion_unit;

    public Tile(int[] pos, Map map) {
        this.tile_pos = pos;
        this.world_pos = new float[] {tile_pos[0] * x_tile_dis + (pos[1] % 2 == 1 ? x_tile_dis / 2 : 0), tile_pos[1] * y_tile_dis};
        this.map = map;
        this.neighbours = new Tile[6];
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
        if (tile_sprite == null) {
            stroke(0);
            fill(tile_col);
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

}

class Tile_Improvement {
    Statistics_Block improvement;
    //Bonus or Luxury resource acquired

    // public void on_destroy() { tile.stats -= improvement;}
}