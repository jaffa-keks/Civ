float x_off, y_off;
float zoom = 1;
Map map;

float minimap_x=0, minimap_y=500, minimap_scale=1;

void setup() {
  size(1280, 720, P2D);
  screen_width_tiles = (int)(width / x_tile_dis) + 2;
  screen_height_tiles = (int)(height / y_tile_dis) + 2;
  load_base_terrains();

  frameRate(30);
  Civilization[] civs = new Civilization[] {
    new Civilization("Yugoslavia")
  };

  // map = new Map(64, 48, civs);
  map = new Map("maps/earth");
}

void draw() {
  background(0xffcccccc);
  //add zoom here maybe | scale(zoom);
  map.draw_map(x_off, y_off);
  render_minimap();
  //render ui
}

void mouseDragged() {
  if (mouseButton == CENTER) {
    x_off += (pmouseX - mouseX) / zoom;
    x_off = (x_off + map.map_width_f) % map.map_width_f;
    y_off += (pmouseY - mouseY) / zoom;
    y_off = constrain(y_off, 0, map.map_height_f - height / zoom);
  }
}

void mousePressed() {
  Tile clicked = tile_at(world_point());
  println(clicked.tile_pos[0], clicked.tile_pos[1]);
}

float[] world_point() {
    return new float[] {(x_off + mouseX / zoom) % map.map_width_f, y_off + mouseY / zoom};
}

Tile tile_at(float[] world_pos) {
  int ty = (int)(world_pos[1] / y_tile_dis + 0.5f);
  int tx = (int)(world_pos[0] / x_tile_dis + (ty % 2 == 1 ? 0 : 0.5)) % map.map_width;
  return map.tiles[tx][ty];
}

// FOR NOW EVERYONE PLAYS SIMULTANEOUSLY
// IMPLEMENT WHEN IN WAR ORDER OF TURNS FOR CIV

void render_minimap() {
  stroke(0);
  strokeWeight(4);
  noFill();
  rect(minimap_x, minimap_y, map.map_width*minimap_scale, map.map_height*minimap_scale);
  strokeWeight(2);
  for (int y = 0; y < map.map_height; y++) {
    for (int x = 0; x < map.map_width; x++) {
      stroke(map.tiles[x][y].tile_col);
      point(minimap_x + 2 + x*minimap_scale, minimap_y + 2 + y*minimap_scale);
    }
  }
}