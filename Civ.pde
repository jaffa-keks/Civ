float x_off, y_off;
float zoom = 1;
Map map;

void setup() {
  size(1280, 720);
  screen_width_tiles = (int)(width / x_tile_dis) + 2;
  screen_height_tiles = (int)(height / y_tile_dis) + 2;

  frameRate(30);
  Civilization[] civs = new Civilization[] {
    new Civilization("Yugoslavia")
  };

  map = new Map(64, 48, civs);

}

void draw() {
  background(0xffcccccc);
  //add zoom here maybe | scale(zoom);
  map.draw_map(x_off, y_off);
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