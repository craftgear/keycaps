// ---------- customizable parameters ----------

phone_length = 180;
phone_width = 80;
phone_thickness = 8;

phone_edge_radius = 2;
phone_corner_radius = 9;

case_thickness = 2;
pinch_offset = 3;

// ---------- initialization ----------

maxoverhang = 40; // allowable overhang angle from horizontal
yoffset = phone_thickness/2 - phone_edge_radius; // edge radius center offset
long_straight_side = phone_length - 2*phone_corner_radius;
short_straight_side = phone_width - 2*phone_corner_radius;
halflong = long_straight_side/2;
halfshort = short_straight_side/2;
halfthick = phone_thickness/2;


profile_stack = let(r=phone_corner_radius, inc = long_straight_side/50) [
    for(a=[0:9:89]) case_edge_profile3d(halflong+r*cos(a), halfshort+r*sin(a), 180+a),
    for(x=[halflong:-inc:-0.999*halflong])
        case_edge_profile3d(x, phone_width/2, 270, bendcurve(x/halflong)),
    for(a=[90:9:181]) case_edge_profile3d(-halflong+r*cos(a), halfshort+r*sin(a), 180+a),
    for(a=[180:9:269]) case_edge_profile3d(-halflong+r*cos(a), -halfshort+r*sin(a), 180+a),
    for(x=[-halflong:inc:0.999*halflong])
        case_edge_profile3d(x, -phone_width/2, 90, bendcurve(x/halflong)),
    for(a=[-90:9:0]) case_edge_profile3d(halflong+r*cos(a), -halfshort+r*sin(a), 180+a)
];

// ---------- render object ----------

polyhedron_ring(profile_stack);             // edge of case
translate([0,0,-halfthick-case_thickness])  // bottom of case
    linear_extrude(case_thickness)
        offset(r=phone_corner_radius) square([long_straight_side, short_straight_side], center=true);

// Build a polyhedron ring from a stack of polygons. It is assumed that each polygon has [x,y,z] coordinates as its vertices, and the ordering of vertices follows the right-hand-rule with respect to the direction of propagation of each successive polygon.
module polyhedron_ring(stack) {
    nz = len(stack); // number of z layers
    np = len(stack[0]); // number of polygon vertices
    facets = [
        for(i=[0:nz-2])
            for(j=[0:np-1]) let(k1=i*np+j, k4=i*np+((j+1)%np), k2=k1+np, k3=k4+np)
                [k1, k2, k3, k4],
        let(i=nz-1) // connect last to first to close the ring
            for(j=[0:np-1]) let(k1=i*np+j, k2=j, k3=(j+1)%np, k4=i*np+((j+1)%np))
            [k1, k2, k3, k4]
    ];
    polyhedron(flatten(stack), facets, convexity=6);
}

// ---------- functions ----------

// 2d cross section, warped by inner_bend in mm

function case_edge_profile2d(inner_bend=0) = let(
    outr = phone_thickness/2 + case_thickness,
    lipangle = atan2(phone_edge_radius*sin(90+maxoverhang)+yoffset, phone_edge_radius*cos(90+maxoverhang))
    ) [
        for(a=[270:-5:180.1])
            let(y=phone_edge_radius*sin(a)-yoffset, xoff=inner_bend*(y+halfthick)/phone_thickness)
                [phone_edge_radius*cos(a)+xoff, y],
        [-phone_edge_radius+inner_bend*(halfthick-phone_edge_radius)/phone_thickness, -yoffset],
        for(a=[180:-5:90+maxoverhang])
            let(y=phone_edge_radius*sin(a)+yoffset, xoff=inner_bend-inner_bend*(halfthick-y)/phone_thickness)
                [phone_edge_radius*cos(a)+xoff, y],
        for(a=[lipangle:5:269])
            let(y=outr*sin(a), xoff=inner_bend-inner_bend*(halfthick-y)/phone_thickness)
                [outr*cos(a)+xoff, y],
        [0, -outr]
    ];

// position 2d cross section in 3d space

function case_edge_profile3d(x, y, zrotation, inner_bend=0) =
    let(p = case_edge_profile2d(inner_bend)) [
        for(i=[0:len(p)-1]) [ p[i][0]*cos(zrotation)+x, p[i][0]*sin(zrotation)+y, p[i][1] ]
    ];

// bend curve is a cosine-squared function
        
function bendcurve(t) = let(ct = cos(90*t-90)) pinch_offset*(1-ct*ct);

// flatten an array of arrays

function flatten(l) = [ for (a = l) for (b = a) b ] ;