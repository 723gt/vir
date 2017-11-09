#!/usr/bin/env ruby
require "curses"

module Vir
  class Editor
    def initialize
      Curses.init_screen
      Curses.raw
      set_escdelay(25)

      Curses.setpos(0,0)
      Curses.addstr("Press Ctrl + c")
      Curses.refresh

      @win = Curses::Window.new(Curses.lines - 2,Curses.cols,2,0)
      editor_start  
    end

    def editor_start
      @win.scrollok(true)
      begin
      @win.keypad(true)

      x = 0
      y = 0

      loop do
        key = nil
        @win.setpos(y,x)
        key = @win.getch
        if key == Curses::KEY_CTRL_C
          break
        end
          
        case key
          when 127
            @win.setpos(y,x - 1)
            @win.delch
            x -= 1
          when 10
            x = 0
            y += 1
          else
            print_key_info(@win,y,x,key)
            x += 1
        end
      end
      ensure
        Curses.close_screen
      end
    end
    
    def set_escdelay(ms)
      Curses.ESCDELAY = ms
      rescue NotImplementedError
    end

    def print_key_info(win,y,x,key)
      win.setpos(y,x)
      win.addch(key)
    end
  end
end
