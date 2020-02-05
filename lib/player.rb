module FightingGame

  class Player
    require 'concurrent'
    SPEED = 9

    attr_accessor :health, :pos_x, :flip, :status, :name, :ex_meter

    def initialize(window, name, flip=false)
      @name = name
      @tiles = Tileset.new(window, name)
      @pos_y = 335
      @pos_x = 0
      @pos_y = 335
      @flip  = flip
      @max_x = window.width
      @health = 100
      @max_y  = window.height
      @status = 'idle'
      @max_y = window.height
      @window = window
      @ex_meter = 10
      @scale = 1



      move_to flip ? @max_x - 100 - width : 100
      idle!
    end

    def character1!
      @tiles = Tileset.new(@window, 'ken')
      @scale = 3
      @name = 'ken'
    end

    def character2!
      @tiles = Tileset.new(@window, 'rugal')
      @scale = 1
      @name = 'rugal'
    end

    def character3!
      @tiles = Tileset.new(@window, 'joe')
      @scale = 1
      @name = 'joe'
    end

    def character4!
      @tiles = Tileset.new(@window, 'crimsaur')
      @scale = 3
      @name = 'crimsaur'
      @pos_x = 0
      @pos_y = 100
    end

    def character5!
      @tiles = Tileset.new(@window, 'poolio')
      @scale = 1
      @name = 'poolio'
    end




    def special_damage(player2)
      if self.flip == true
        if player2.pos_x >= (self.pos_x - 200)
          if player2.status == 'blocking'
            player2.health -= 2
            self.pos_x += 50
          end
          if player2.status == 'busy' || player2.status == 'idle'
            hit = Concurrent::ScheduledTask.new(0.6)do
            player2.hit!
            player2.health -= 25
            player2.pos_x -= 100 if player2.pos_x > 50
            if player2.health <= 0
              player2.knockout!
              self.victory!
            end
          end
          hit.execute
          end
        end
      else
        if self.pos_x >= (player2.pos_x - 200)
          if player2.status == 'blocking'
            player2.health -= 2
            self.pos_x -= 50
          end
          if player2.status == 'busy' || player2.status == 'idle'
            hit = Concurrent::ScheduledTask.new(0.6)do
            player2.hit!
            player2.health -= 25
            player2.pos_x += 50 if player2.pos_x < 650
            if player2.health <= 0
              player2.knockout!
              self.victory!
            end
            hit.execute
            end
          end
        end
      end
    end






    def punch_damage(player2)
      if self.flip == true
        if player2.pos_x >= (self.pos_x - 200)
          if player2.status == 'blocking'
            player2.health -= 2
            self.pos_x += 50
          end
          if player2.status == 'busy' || player2.status == 'idle'
            hit = Concurrent::ScheduledTask.new(0.2)do
            player2.hit!
            player2.health -= 10
            self.ex_meter += 10 if self.ex_meter < 100
            player2.pos_x -= 50 if player2.pos_x > 50
            if player2.health <= 0
              player2.knockout!
              self.victory!
            end
          end
          hit.execute
          end
        end
      else
        if self.pos_x >= (player2.pos_x - 200)
          if player2.status == 'blocking'
            player2.health -= 2
            self.pos_x -= 50
          end
          if player2.status == 'busy' || player2.status == 'idle'
            player2.pos_x += 50 if player2.pos_x < 650
            hit = Concurrent::ScheduledTask.new(0.2)do
            player2.hit!
            player2.health -= 10
            self.ex_meter += 10 if self.ex_meter < 100
            if player2.health <= 0
              player2.knockout!
              self.victory!
            end
          end
          hit.execute
          end
        end
      end
    end

    def kick_damage(player2)
      if self.flip == true
        if player2.pos_x >= (self.pos_x - 200)
          if player2.status == 'blocking'
            player2.health -= 2
            self.pos_x += 50
          end
          if player2.status == 'busy' || player2.status == 'idle'
            hit = Concurrent::ScheduledTask.new(0.2)do
            player2.hit!
            player2.pos_x -= 150 if player2.pos_x > 50
            player2.health -= 10
            self.ex_meter += 10 if self.ex_meter < 100
            if player2.health <= 0
              player2.knockout!
              self.victory!
            end
          end
          hit.execute
          end
        end
      else
        if self.pos_x >= (player2.pos_x - 200)
          if player2.status == 'blocking'
            player2.health -= 2
            self.pos_x -= 50
          end
          if player2.status == 'busy' || player2.status == 'idle'
            hit = Concurrent::ScheduledTask.new(0.2)do
            player2.hit!
            player2.pos_x += 150 if player2.pos_x < 650
            player2.health -= 10
            self.ex_meter += 10 if self.ex_meter < 100
            if player2.health <= 0
              player2.knockout!
              self.victory!
            end
          end
          hit.execute
          end

        end
      end
    end


def special!
  if @ex_meter >= 20
    @ex_meter -= 20
  if @status == 'idle'
    @busy = true
    @pos_y = 335
    @tiles.special! do
      @busy = false
      idle!
    end
    @status = 'busy'
  end
end
end

    def idle!
      return if @busy
      @tiles.idle!
      @pos_y = 335
      @status = 'idle'
    end


    def knockout!
      @status = 'busy'
      @pos_y = 450
      @tiles.knockout!


    end

    def victory!
      @status = 'busy'
      @pos_y = 335
      @tiles.victory!
    end

    def walking!
      if @status == 'idle'
        @pos_y = 335
        @tiles.walking!
        @status = 'busy'
      end
    end

    def hit!
      # hit = Concurrent::ScheduledTask.new(0.4)do
      @pos_y = 335
      @tiles.hit! do
        @busy = false
        idle!
      end
      # end
      # hit.execute
    end

    def crouch!
      if @status == 'idle'
        @tiles.crouch!
        @pos_y = 400
        @status = 'crouch'
      end
    end

    def blocking!
      if @status == 'idle'
        @pos_y = 335
        @tiles.blocking!
        @status = 'blocking'
      end
    end

    def punch!
      if @status == 'idle'
        @busy = true
        @pos_y = 335
        @tiles.punch! do
          @busy = false
          idle!
        end
        @status = 'busy'
      end
    end

    def kick!
      if @status == 'idle'
        @busy = true
        @pos_y = 335
        @tiles.kick! do
          @busy = false
          idle!
        end
        @status = 'busy'
      end
    end

    def move_to(x)
      @pos_x = x
    end

    def move_left
      if self.health >= 1
        @pos_x -= SPEED
      end
    end

    def move_right
      if self.health >= 1

        @pos_x += SPEED
      end
    end

    def left
      @pos_x
    end

    def right
      @pos_x + width
    end

    def width
      @tiles.width * @scale
    end

    def draw
      pos_x   = @pos_x + (@flip ? width : 0)
      scale_x = @scale * (@flip ? -1 : 1)

      @tiles.draw(pos_x, @pos_y, 1, scale_x, @scale)
    end

    private

    class Tileset < Hash

      def initialize(window, name)
        self[:idle]     = FightingGame::Animation.new(window, "#{name}/idle")
        self[:walking]  = FightingGame::Animation.new(window, "#{name}/walking")
        self[:blocking] = FightingGame::Animation.new(window, "#{name}/blocking")
        self[:punch]    = FightingGame::Animation.new(window, "#{name}/punch")
        self[:kick]     = FightingGame::Animation.new(window, "#{name}/kick")
        self[:crouch]   = FightingGame::Animation.new(window, "#{name}/crouch")
        self[:hit]      = FightingGame::Animation.new(window, "#{name}/hit")
        self[:knockout] = FightingGame::Animation.new(window, "#{name}/ko")
        self[:victory] = FightingGame::Animation.new(window, "#{name}/victory")
        self[:special] = FightingGame::Animation.new(window, "#{name}/special")
        idle!
      end


      def victory!
        @current_animation = self[:victory]
      end

      def special!(&callback)
        @current_animation = self[:special]
        @current_animation.play_once &callback
      end

      def hit!(&callback)
        @current_animation = self[:hit]
        @current_animation.play_once &callback
      end

      def knockout!()
        @current_animation = self[:knockout]
      end

      def idle!
        @current_animation = self[:idle]
      end

      def walking!

        @current_animation = self[:walking]
      end

      def blocking!
        @current_animation = self[:blocking]
      end

      def crouch!
        @current_animation = self[:crouch]
      end

      def punch!(&callback)
        @current_animation = self[:punch]
        @current_animation.play_once &callback
      end

      def kick!(&callback)
        @current_animation = self[:kick]
        @current_animation.play_once &callback
      end

      def width
        @current_animation.width
      end

      def draw(*args)
        @current_animation.draw *args
      end

    end
  end

end
