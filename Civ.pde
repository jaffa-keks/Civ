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

  //for (Tile t : map.tiles[2][1].neighbours)
  //  println(t.tile_pos[0], t.tile_pos[1]);
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

// FOR NOW EVERYONE PLAYS SIMULTANEOUSLY
// IMPLEMENT WHEN IN WAR ORDER OF TURNS FOR CIV