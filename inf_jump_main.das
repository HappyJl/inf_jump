require daslib/media

let
    CUBE_COLOR      = 0xFF3F70
    GROUND_COLOR    = 0x504022
    SKY_COLOR       = 0xB0E0FF
    JUMP_VELOCITY   = 642
    MOVE_VELOCITY   = 0
    COLUMN_COLOR    = 0xff00ff

struct Cube
    position: float2
    velocity: float2
    move: float
    size: float
    accelerating: float

struct Platform
    posY: float
    width: float
    holeTop: float
    holeBottom: float

var
    RAND_SEED: int4
    camera_x = 0.0
    right_pressed = false
    left_pressed = false
    cube: Cube
    platforms: array<Platform>


def reset_cube(var c: Cube)
    c.position = float2(get_screen_width()/2)
    c.velocity = float2(0.0)
    c.accelerating = 0.0
    c.size = 15.0
    c.move = -PI

def move2vec(move: float): float2
    return float2(sin(move), cos(move))

def update_cube(var c: Cube; dt: float)
    c.position = c.position + c.velocity * dt
    c.velocity.y += float(JUMP_VELOCITY) * dt
    c.velocity.x += float(MOVE_VELOCITY) * dt
    if c.position.x > float(get_screen_width()) / 1.0
        c.position.x = float(get_screen_width()) / 1.0
    if c.position.x < 0.0
        c.position.x = 0.0
    if c.position.y > float(get_screen_height()) / 1.08
        c.position.y = float(get_screen_height()) / 1.08

def init_platform(var p: Platform)
    p.width = 200.0
    p.posY = camera_x + float(get_screen_height())
    p.holeTop = float(get_screen_height() - 300)
    p.holeBottom = 20.0

def render_platform(var p: Platform)
    fill_rect(int(p.posY - camera_x), int(p.holeTop), int(p.width), int(p.holeBottom), COLUMN_COLOR)
    fill_rect(int(p.posY + camera_x), int(p.holeBottom + 100.0), int(p.width), int(p.holeBottom), COLUMN_COLOR)
    
def jump_cube(var c: Cube)
    c.velocity.y = clamp(c.velocity.y - 600.0, -600.0, -600.0)
def move_cube_left(var c: Cube; dt: float)
    //c.velocity.x = clamp(c.velocity.x - 1.0, -300.0, -1.0)
    c.velocity += move2vec(c.move) * 50.0 * 4.0f * dt
    c.accelerating = 0.05

def move_cube_rigth(var c: Cube)
    c.velocity.x = clamp(c.velocity.x + 300.0, 300.0, 300.0)

def move_cube_down(var c: Cube)
    c.velocity.x = clamp(c.velocity.x, 0.0, 0.0)
    
def render_cube(var c: Cube)
    let x = int(c.position.x - camera_x - c.size * 0.5)
    let y = int(c.position.y - c.size * 0.5)
    fill_rect(x, y, int(c.size), int(c.size), CUBE_COLOR)

def render_background(t: float)
    fill_rect(0, 0, get_screen_width(), get_screen_height(), SKY_COLOR)

def render_ground()
    fill_rect(0, get_screen_height() - 50, get_screen_width(), 200, GROUND_COLOR)
   
def check_for_new_platform()
    if length(platforms) == 0 || platforms[length(platforms) - 1].posY < camera_x + float(get_screen_height()) - 400.0
        var p: Platform
        init_platform(p)
        push(platforms, p)

def remove_out_of_screen_platform()
    let index = find_index_if(platforms) <| $(item)
        return item.posY + item.width < camera_x - float(get_screen_height()) * 0.5
    if index >= 0
        erase(platforms, index)
[export]
def initialize
    set_window_title("inf jump")
    reset_cube(cube)

def update_gameplay(dt: float)
    update_cube(cube, dt)
    for p in platforms
        if(cube.position.y == p.posY)
            jump_cube(cube) 
    check_for_new_platform()
    remove_out_of_screen_platform()
    

[export]
def act(dt: float)
    // print("act dt={dt}\n")
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    if get_key(VK_A)
        move_cube_left(cube, dt)
    update_gameplay(dt)


[export]
def draw()
    render_background(camera_x)
    render_ground()
    for p in platforms
        render_platform(p)
    render_cube(cube)
    

