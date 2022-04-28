require daslib/media

let
    CUBE_COLOR      = 0xFF3F70
    GROUND_COLOR    = 0x504022
    SKY_COLOR       = 0xB0E0FF
    COLUMN_COLOR    = 0xff00ff
    JUMP_VELONCITY  = 400.0
    MOVE_VELONCITY  = 2000.0

struct Cube
    position: float2
    velocity: float2
    move: float
    MoveState: float
    size: float
    accelerating: float
    JumpState: float

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
    c.JumpState = 0.0;

//------------------------------------------------------- move trash cube -----------------------------------------------------------------------
def movev2(move: float): float2
    return float2(cos(move), sin(move))

def cube_accelerate(var c: Cube; dt: float)
    c.velocity += movev2(c.move) * MOVE_VELONCITY * dt

def cube_brake(var c: Cube; dt: float)
    if length(c.velocity) < 20.0
        c.velocity = float2(0.0)
    else
        c.velocity -= normalize(c.velocity) * 2000.0 * dt

def jump_cube(var c: Cube)
    c.velocity.y = clamp(c.velocity.y -400.0, -400.0, -400.0)

def wrap(var v: float2&)
    if v.x < 0.0
        v.x += float(get_screen_width())
    if v.x > float(get_screen_width())
        v.x -= float(get_screen_width())

def update_cube(var c: Cube; dt:float)
    c.position += c.velocity * dt
    c.velocity.y += float(JUMP_VELONCITY) * dt
    if c.position.y > float(get_screen_height()) - 50.0
        c.velocity.y = 0.0
    wrap(c.position)

//------------------------------------------------------- move trash cube -----------------------------------------------------------------------

//------------------------------------------------------- render some shit ----------------------------------------------------------------------
def render_cube(var c: Cube)
    let x = int(c.position.x - camera_x - c.size * 0.5)
    let y = int(c.position.y - c.size * 0.5)
    fill_rect(x, y, int(c.size), int(c.size), CUBE_COLOR)

def render_platform()
    fill_rect(500, 500, 200, 25, GROUND_COLOR)

def render_background(t: float)
    fill_rect(0, 0, get_screen_width(), get_screen_height(), SKY_COLOR)

def render_ground()
    fill_rect(0, get_screen_height() - 50, get_screen_width(), 200, GROUND_COLOR)

//------------------------------------------------------- render some shit ---------------------------------------------------------------------- 

[export]
def initialize
    set_window_title("inf jump")
    reset_cube(cube)


def update_gameplay(dt: float)
    update_cube(cube, dt)

[export]
def act(dt: float)
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    // print("act dt={dt}\n")

    if get_key(VK_A) || get_key(VK_LEFT)
        cube_accelerate(cube, dt)
    if get_key(VK_D) || get_key(VK_RIGHT)
        cube_accelerate(cube, -dt)
    if get_key_down(VK_W) || get_key_down(VK_UP)
        jump_cube(cube)
    if !(get_key(VK_A) || get_key(VK_D) || get_key(VK_RIGHT) || get_key(VK_LEFT))
        cube_brake(cube, dt)
    
    update_gameplay(dt)
[export]
def draw()
    render_background(camera_x)
    render_ground()
    render_platform()
    render_cube(cube)
    

