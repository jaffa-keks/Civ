class Unit_Entity {
    Unit unit;
    Civilization civ;

    Map map;
    Tile tile;
    int move_left;

    protected Unit_Entity same_type_unit_on_tile(Tile t) { return null; }
    
    public void move_to_adjacent_tile(Tile t) {
        // assert is adjacent
        // if (t instanceof UnpassableTile) <- Mountain, Volcano...
        Unit_Entity on_tile = same_type_unit_on_tile(t);
        if (on_tile == null) {
            if (t.move_penalty <= move_left) {
                move_left -= t.move_penalty;
                tile = t;
                // for multiplayer send unit moved
            }
        } else {
            if (on_tile.civ == civ)
                return; //or implement swap position
            else {
                // combat
            }
        }
    }

    public void on_turn_start() {

    }

}

class Combat_Unit_Entity extends Unit_Entity {
    protected Unit_Entity same_type_unit_on_tile(Tile t) {
        return t.combat_unit;
    }
}

class Utility_Unit_Entity extends Unit_Entity {
    protected Unit_Entity same_type_unit_on_tile(Tile t) {
        return t.utility_unit;
    }
}

class Religion_Unit_Entity extends Unit_Entity {
    protected Unit_Entity same_type_unit_on_tile(Tile t) {
        return t.religion_unit;
    }
}

class Trader_Unit_Entity extends Unit_Entity {
    public void move_to_adjacent_tile(Tile t) {

    }
}