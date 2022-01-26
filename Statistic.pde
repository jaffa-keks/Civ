class Statistic {
    int amount;

    String name;
    PImage icon;
}

class Statistics_Block {
    Statistic[] stats = new Statistic[] {
        new Food(),
        new Production(),
        new Gold(),
        new Science(),
        new Faith(),
        new Culture()
    };

    public void add(Statistics_Block s) {
        for (int i = 0; i < stats.length; i++)
            stats[i].amount += s.stats[i].amount;
    }

    public void add(Statistic s) {
        for (int i = 0; i < stats.length; i++) {
            if (s.getClass() == stats[i].getClass()) {
                stats[i].amount += s.amount;
                return;
            }
        }
    }

    public void consume(Statistic s) {
        for (int i = 0; i < stats.length; i++) {
            if (s.getClass() == stats[i].getClass()) {
                stats[i].amount -= s.amount;
                return;
            }
        }
    }

    public void add(int k, Stat s) {
        stats[s.ordinal()].amount += k;
    }

    public void consume(int k, Stat s) {
        stats[s.ordinal()].amount -= k;
    }

}

enum Stat {
    FOOD, PRODUCTION, GOLD, SCIENCE, FAITH, CULTURE
}

class Food extends Statistic {

}

class Production extends Statistic {
    
}

class Gold extends Statistic {
    
}

class Science extends Statistic {
    
}

class Faith extends Statistic {
    
}

class Culture extends Statistic {
    
}