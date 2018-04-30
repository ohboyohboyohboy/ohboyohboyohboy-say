#!/usr/bin/ruby
# encoding: utf-8
#
# author: Kyle Yetter
#

module Say
  VERSION     = "1.2.0"
  FormatError = Class.new( StandardError )

  module XTerm256Colors
    ############################################################################
    ######################### XTERM 256 COLOR CONSTANTS ########################
    ############################################################################
    X256_COLOR_TABLE =
      [
        0x000000, 0x00005f, 0x000087, 0x0000af, 0x0000d7, 0x0000ff,
        0x005f00, 0x005f5f, 0x005f87, 0x005faf, 0x005fd7, 0x005fff,
        0x008700, 0x00875f, 0x008787, 0x0087af, 0x0087d7, 0x0087ff,
        0x00af00, 0x00af5f, 0x00af87, 0x00afaf, 0x00afd7, 0x00afff,
        0x00d700, 0x00d75f, 0x00d787, 0x00d7af, 0x00d7d7, 0x00d7ff,
        0x00ff00, 0x00ff5f, 0x00ff87, 0x00ffaf, 0x00ffd7, 0x00ffff,
        0x5f0000, 0x5f005f, 0x5f0087, 0x5f00af, 0x5f00d7, 0x5f00ff,
        0x5f5f00, 0x5f5f5f, 0x5f5f87, 0x5f5faf, 0x5f5fd7, 0x5f5fff,
        0x5f8700, 0x5f875f, 0x5f8787, 0x5f87af, 0x5f87d7, 0x5f87ff,
        0x5faf00, 0x5faf5f, 0x5faf87, 0x5fafaf, 0x5fafd7, 0x5fafff,
        0x5fd700, 0x5fd75f, 0x5fd787, 0x5fd7af, 0x5fd7d7, 0x5fd7ff,
        0x5fff00, 0x5fff5f, 0x5fff87, 0x5fffaf, 0x5fffd7, 0x5fffff,
        0x870000, 0x87005f, 0x870087, 0x8700af, 0x8700d7, 0x8700ff,
        0x875f00, 0x875f5f, 0x875f87, 0x875faf, 0x875fd7, 0x875fff,
        0x878700, 0x87875f, 0x878787, 0x8787af, 0x8787d7, 0x8787ff,
        0x87af00, 0x87af5f, 0x87af87, 0x87afaf, 0x87afd7, 0x87afff,
        0x87d700, 0x87d75f, 0x87d787, 0x87d7af, 0x87d7d7, 0x87d7ff,
        0x87ff00, 0x87ff5f, 0x87ff87, 0x87ffaf, 0x87ffd7, 0x87ffff,
        0xaf0000, 0xaf005f, 0xaf0087, 0xaf00af, 0xaf00d7, 0xaf00ff,
        0xaf5f00, 0xaf5f5f, 0xaf5f87, 0xaf5faf, 0xaf5fd7, 0xaf5fff,
        0xaf8700, 0xaf875f, 0xaf8787, 0xaf87af, 0xaf87d7, 0xaf87ff,
        0xafaf00, 0xafaf5f, 0xafaf87, 0xafafaf, 0xafafd7, 0xafafff,
        0xafd700, 0xafd75f, 0xafd787, 0xafd7af, 0xafd7d7, 0xafd7ff,
        0xafff00, 0xafff5f, 0xafff87, 0xafffaf, 0xafffd7, 0xafffff,
        0xd70000, 0xd7005f, 0xd70087, 0xd700af, 0xd700d7, 0xd700ff,
        0xd75f00, 0xd75f5f, 0xd75f87, 0xd75faf, 0xd75fd7, 0xd75fff,
        0xd78700, 0xd7875f, 0xd78787, 0xd787af, 0xd787d7, 0xd787ff,
        0xd7af00, 0xd7af5f, 0xd7af87, 0xd7afaf, 0xd7afd7, 0xd7afff,
        0xd7d700, 0xd7d75f, 0xd7d787, 0xd7d7af, 0xd7d7d7, 0xd7d7ff,
        0xd7ff00, 0xd7ff5f, 0xd7ff87, 0xd7ffaf, 0xd7ffd7, 0xd7ffff,
        0xff0000, 0xff005f, 0xff0087, 0xff00af, 0xff00d7, 0xff00ff,
        0xff5f00, 0xff5f5f, 0xff5f87, 0xff5faf, 0xff5fd7, 0xff5fff,
        0xff8700, 0xff875f, 0xff8787, 0xff87af, 0xff87d7, 0xff87ff,
        0xffaf00, 0xffaf5f, 0xffaf87, 0xffafaf, 0xffafd7, 0xffafff,
        0xffd700, 0xffd75f, 0xffd787, 0xffd7af, 0xffd7d7, 0xffd7ff,
        0xffff00, 0xffff5f, 0xffff87, 0xffffaf, 0xffffd7, 0xffffff,
        0x080808, 0x121212, 0x1c1c1c, 0x262626, 0x303030, 0x3a3a3a,
        0x444444, 0x4e4e4e, 0x585858, 0x626262, 0x6c6c6c, 0x767676,
        0x808080, 0x8a8a8a, 0x949494, 0x9e9e9e, 0xa8a8a8, 0xb2b2b2,
        0xbcbcbc, 0xc6c6c6, 0xd0d0d0, 0xdadada, 0xe4e4e4, 0xeeeeee
      ].freeze

    X256_FG_MASK      = "\e[38;5;%im".freeze
    X256_BG_MASK      = "\e[48;5;%im".freeze
    X256_RX_RGB_HEX_3 = %r<\A \s* 0? x? (\h) (\h) (\h) \s* \z>ix
    X256_RX_RGB_HEX_6 = %r<\A \s* 0? x? (\h{2}) (\h{2}) (\h{2}) \s* \z>ix

    class << self
      def xterm256_color_index(color)
        xterm_256_cache.fetch(color) do
          xterm_256_cache[color] = compute_xterm256_color_index(color)
        end
      end

      def xterm256_fg(color)
        sprintf(X256_FG_MASK, xterm256_color_index(color))
      end

      def xterm256_bg(color)
        sprintf(X256_BG_MASK, xterm256_color_index(color))
      end

      private

      def xterm_256_cache
        @xterm_256_cache ||= {}
      end

      def xterm_256_rgb_vectors
        @xterm_256_rgb_vectors ||= X256_COLOR_TABLE.map { |int| integer_to_rgb(int) }.freeze
      end

      def compute_xterm256_color_index(color)
        color_integer = normalize_rgb_integer(color)
        target_rgb    = integer_to_rgb(color_integer)

        best_distance = 0XFFFFFF
        best_index    = -1

        xterm_256_rgb_vectors.each_with_index do |rgb, index|
          metric = rgb_vector_distance_squared(target_rgb, rgb)
          if metric < best_distance
            best_distance = metric
            best_index    = index
          end
        end

        return best_index + 16
      end

      def normalize_rgb_integer(value)
        integer_value =
          case value
          when Array   then rgb_to_integer(*value)
          when String  then parse_rgb_string(value)
          else value.to_i
          end

        integer_value & 0xFFFFFF
      end

      def parse_rgb_string(string)
        if string =~ X256_RX_RGB_HEX_3
          string = "#{ $1 }#{ $1 }#{ $2 }#{ $2 }#{ $3 }#{ $3 }"
        end

        value =
          if string =~ X256_RX_RGB_HEX_6
            rgb_to_integer($1.to_i(16), $2.to_i(16), $3.to_i(16))
          else
            fail ArgumentError, "Invalid RGB color string value: #{ string.inspect }"
          end

        return value
      end

      def rgb_to_integer(r = 0, g = 0, b = 0)
        ((r.to_i & 0xFF) << 16) | ((g.to_i & 0xFF) << 8) | (b.to_i & 0xFF)
      end

      def integer_to_rgb(integer)
        [
          (integer >> 16) & 0xFF,
          (integer >> 8) & 0xFF,
          integer & 0xFF
        ].freeze
      end

      def rgb_vector_distance_squared(rgb_1, rgb_2)
        r1, g1, b1 = rgb_1
        r2, g2, b2 = rgb_2

        return (
          (r1 - r2) ** 2 +
          (b1 - b2) ** 2 +
          (g1 - g2) ** 2
        )
      end
    end

    %i( xterm256_color_index xterm256_fg xterm256_bg ).each do |method_name|
      define_method(method_name) do |color_value|
        XTerm256Colors.send(method_name, color_value)
      end

      private method_name
    end
  end

  extend XTerm256Colors
  include XTerm256Colors

  ############################################################################
  ##################### Basic ANSI Color Escape Constants ####################
  ############################################################################

  ESCAPE_MAP      =
    Hash.new { | h, k | k }.
      update(
        'n'   => "\n",
        't'   => "\t",
        'r'   => "\r",
        'e'   => "\e",
        '\\'  => "\\",
        'a'   => "\a",
        "s"   => "\s",
        'b'   => "\b",
        '%'   => '%%'
      )

  BACKGROUND_CODE = "\e[4%im"
  FOREGROUND_CODE = "\e[3%im"
  COLOR_VALUES    =
    {
      "white"   => 7,
      "black"   => 0,
      "cyan"    => 6,
      "blue"    => 4,
      "green"   => 2,
      "red"     => 1,
      "magenta" => 5,
      "yellow"  => 3
    }

  COLOR_NAMES     =
    {
      "bla" => "black",    "gree" => "green",       "w" => "white",
      "blac" => "black",   "green" => "green",      "wh" => "white",
      "black" => "black",  "m" => "magenta",        "whi" => "white",
      "blu" => "blue",     "ma" => "magenta",       "whit" => "white",
      "blue" => "blue",    "mag" => "magenta",      "white" => "white",
      "c" => "cyan",       "mage" => "magenta",     "y" => "yellow",
      "cy" => "cyan",      "magen" => "magenta",    "ye" => "yellow",
      "cya" => "cyan",     "magent" => "magenta",   "yel" => "yellow",
      "cyan" => "cyan",    "magenta" => "magenta",  "yell" => "yellow",
      "g" => "green",      "r" => "red",            "yello" => "yellow",
      "gr" => "green",     "re" => "red",           "yellow" => "yellow",
      "gre" => "green",    "red" => "red"
    }

  STYLE_CODES     =
    {
      '*' => "\e[1m",
      '_' => "\e[4m",
      '~' => "\e[7m",
      '!' => "\e[5m"
    }

  ##################################################################################################
  ######################################## Regular Expressions #####################################
  ##################################################################################################

  RX_COLOR_WORD  = %r< [a-z]+ >xi
  RX_HEX_CODE    = %r< 0? x? (?: \h{6} | \h{3} ) >xi
  RX_COLOR_VALUE = Regexp.union(RX_COLOR_WORD, RX_HEX_CODE)

  RX_TAGS =
    %r`
      ( [\*~!_]* )
    | ( #{ RX_COLOR_VALUE } (?: @ #{ RX_COLOR_VALUE } )?
      | @ #{ RX_COLOR_VALUE }
      )
    `xi

  RX_COLOR_ARG =
    %r`
      % \( ( #{ RX_TAGS } ) \)
      ( [\-\+0\s\#]? \d* (?:\.\d+)? [hlI]? [bcdEefGgiopsuXx] )
    `xi

  RX_ESCAPE    = /^\\(.)/
  RX_CLOSE_TAG = %r(^</#{ RX_TAGS }>)
  RX_OPEN_TAG  = %r(^<#{ RX_TAGS }>)
  RX_TEXT      = %r(^(.+?)(?=(?:\\.|</?#{ RX_TAGS }>|\Z)))m

  BAD_CLOSE    = %(bad format close tag: expected `%s', but got `%s')

  ##################################################################################################
  ############################################## Methods ###########################################
  ##################################################################################################

  def self.color_value( name )
    if name and not name.empty?
      full_name = COLOR_NAMES.fetch( name.downcase ) do | i |
        raise( FormatError, "`%s' is not a valid color name" % name )
      end
      COLOR_VALUES[ full_name ]
    end
  end

  def self.color_escape_code(fg_or_bg, color_name)
    if color_name && !color_name.empty?
      if color_name =~ RX_HEX_CODE
        fg_or_bg == :bg ? xterm256_bg(color_name) : xterm256_fg(color_name)
      else
        full_name =
          COLOR_NAMES.fetch(color_name.downcase) do | i |
            fail FormatError, "`%s' is not a valid color name" % color_name
          end
        sprintf(fg_or_bg == :bg ? BACKGROUND_CODE : FOREGROUND_CODE, COLOR_VALUES[full_name])
      end
    end
  end

  def self.color_scan( text )
    foreground = []
    background = []
    styles     = []
    out = ''

    text = text.gsub( RX_COLOR_ARG, '<\1>%\4</\1>' )

    until text.nil? or text.empty?
      print_escape = false

      case text
      when RX_ESCAPE
        text = $'
        out << ESCAPE_MAP[ $1 ]

      when RX_CLOSE_TAG
        text = $'

        if style_char = $1
          style_char.each_char { | c | styles.delete( STYLE_CODES.fetch(c) ) }
        elsif colors = $2
          fg, bg = colors.split( '@', 2 )

          if value = color_escape_code(:fg, fg)
            if current = foreground.last and current != value
              display_map = COLOR_VALUES.invert
              expected    = display_map[ current ]
              got         = display_map[ value ]
              fail FormatError, BAD_CLOSE % [ expected, got ]
            end
            foreground.pop
          end

          if value = color_escape_code(:bg, bg)
            if current = background.last and current != value
              display_map = COLOR_VALUES.invert
              expected    = display_map[current]
              got         = display_map[value]
              fail FormatError, BAD_CLOSE % [expected, got]
            end
            background.pop
          end
        end

        print_escape = true

      when RX_OPEN_TAG
        text = $'

        if style_char = $1
          style_char.each_char { |c| styles << STYLE_CODES.fetch(c) }
        elsif colors = $2
          fg, bg = colors.split('@', 2)
          value = color_escape_code(:fg, fg) and foreground << value
          value = color_escape_code(:bg, bg) and background << value
        end

        print_escape = true

      when RX_TEXT
        text = $'
        out << $1

      else
        raise "this shouldn't happen: (#{ __FILE__ }@#{ __LINE__ })"

      end

      if print_escape
        out << "\e[0m"
        value = foreground.last and out << value
        value = background.last and out << value
        out << styles.join('')
      end
    end

    if foreground.length + background.length + styles.length > 0
      out << "\e[0m"
    end

    return out
  end

  def say_format( *args )
    args = [ args ].flatten!
    format = args.shift.to_s
    sprintf( Say.color_scan( format ), *args )
  end

  def say_print( *args )
    print( say_format( *args ) )
  end

  def say( *args )
    puts( say_format( *args ) )
  end

  module_function :say_format, :say, :say_print
end
