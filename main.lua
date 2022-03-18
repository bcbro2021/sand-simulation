local W,H = 500,500;
local PSIZE = 4;
local lual = love

local particles = {};
local mstate = 0;

local function reset()
	particles = {};
	for y=0,W/PSIZE,1 do
    	local row = {}
    	for x=0,W/PSIZE,1 do
        	table.insert(row, {x*PSIZE,y*PSIZE,"air","none"});
    	end
    	table.insert(particles, row);
	end
end
reset();

local function collidepoint(point, pos)
	if point[1] > pos[1] then
		if point[1] < pos[1] + PSIZE then
			if point[2] > pos[2] then
				if point[2] < pos[2] + PSIZE then
					return true
				end
			end
		end
	else
		return false
	end
end

-- particle functions
local function update_part(part,name,type,color)
	part[3] = name;
	part[4] = type;
	lual.graphics.setColor(color[1],color[2],color[3]);
	lual.graphics.rectangle("fill",part[1],part[2],PSIZE,PSIZE);
end

local function draw_part(part,color)
	lual.graphics.setColor(color[1],color[2],color[3]);
	lual.graphics.rectangle("fill",part[1],part[2],PSIZE,PSIZE);
end

function lual.load()
	lual.window.setMode(W,H);
end

function lual.draw()
	if lual.mouse.isDown(1) then
		local mx, my = lual.mouse.getPosition();
		for y in ipairs(particles) do
        	for x in ipairs(particles[y]) do
				local particle = particles[y][x];
				if collidepoint({mx,my},{particle[1],particle[2]}) then
					if mstate == 0 then
						particle[3] = "sand";
						particle[4] = "solid";
					elseif mstate == 1 then
						particle[3] = "air";
						particle[4] = "none";
					elseif mstate == 2 then
						particle[3] = "water";
						particle[4] = "liquid";
					elseif mstate == 3 then
						particle[3] = "lava";
						particle[4] = "liquid";
					elseif mstate == 4 then
						particle[3] = "obi";
						particle[4] = "unmv";
					end
				end
			end
		end
	elseif lual.mouse.isDown(5) then
        mstate = 1;
	elseif lual.mouse.isDown(4) then
		mstate = 0;
	elseif lual.mouse.isDown(3) then
		reset();
	elseif lual.mouse.isDown(2) then
		mstate = 2;
	elseif lual.keyboard.isDown("l") then
		mstate = 3;
	elseif lual.keyboard.isDown("o") then
		mstate = 4;
	end

	for y in ipairs(particles) do
		for x in ipairs(particles[y]) do
			if #particles >= y+1 then
				if x-1 > 0 then
					if #particles[y] >= x+1 then
						local particle = particles[y][x];
						local downparticle = particles[y+1][x];
						local downleftparticle = particles[y+1][x-1];
						local downrightparticle = particles[y+1][x+1];
						local leftparticle = particles[y][x-1];
						local rightparticle = particles[y][x+1];
						local num = math.random(1,2);

						-- solids
						if particle[4] == "solid" then
							if downparticle[4] == "none" then
								if particle[3] == "sand" then
									update_part(downparticle,"sand","solid",{1.00, 0.87, 0.61});
								end
								particle[3] = "air";
								particle[4] = "none";

							elseif downleftparticle[4] == "none" and num == 1 then
								if particle[3] == "sand" then
									update_part(downleftparticle,"sand","solid",{1.00, 0.87, 0.61});
								end
								particle[3] = "air";
								particle[4] = "none";

							elseif downrightparticle[4] == "none" and num == 2 then
								if particle[3] == "sand" then
									update_part(downrightparticle,"sand","solid",{1.00, 0.87, 0.61});
								end
								particle[3] = "air";
								particle[4] = "none";
							end

						-- liquids
						elseif particle[4] == "liquid" then
							if downparticle[4] == "none" then
								if particle[3] == "water" then
									update_part(downparticle,"water","liquid",{0.23, 0.90, 1.00});
								elseif particle[3] == "lava" then
									update_part(downparticle,"lava","liquid",{1.00, 0.53, 0.11});
								end
								particle[3] = "air";
								particle[4] = "none";
							elseif downparticle[3] == "lava" and particle[3] == "water" then
								update_part(downparticle,"obi","unmv",{1.00, 0.87, 0.61});
								particle[3] = "air";
								particle[4] = "none";

							elseif downparticle[3] == "water" and particle[3] == "lava" then
								update_part(downparticle,"obi","unmv",{1.00, 0.87, 0.61});
								particle[3] = "air";
								particle[4] = "none";
							
							elseif rightparticle[4] == "none" and downrightparticle[4] == "none" and num == 1 then
								if particle[3] == "water" then
									update_part(downrightparticle,"water","liquid",{0.23, 0.90, 1.00});
								elseif particle[3] == "lava" then
									update_part(downrightparticle,"lava","liquid",{1.00, 0.53, 0.11});
								end
								particle[3] = "air";
								particle[4] = "none";

							elseif leftparticle[4] == "none" and downleftparticle[4] == "none" and num == 2 then
								if particle[3] == "water" then
									update_part(downleftparticle,"water","liquid",{0.23, 0.90, 1.00});
								elseif particle[3] == "lava" then
									update_part(downleftparticle,"lava","liquid",{1.00, 0.53, 0.11});
								end
								particle[3] = "air";
								particle[4] = "none";

							elseif rightparticle[4] == "none" and num == 1 then
								if particle[3] == "water" then
									update_part(rightparticle,"water","liquid",{0.23, 0.90, 1.00});
								elseif particle[3] == "lava" then
									update_part(rightparticle,"lava","liquid",{1.00, 0.53, 0.11});
								end
								particle[3] = "air";
								particle[4] = "none";

							elseif leftparticle[4] == "none" and num == 2 then
								if particle[3] == "water" then
									update_part(leftparticle,"water","liquid",{0.23, 0.90, 1.00});
								elseif particle[3] == "lava" then
									update_part(leftparticle,"lava","liquid",{1.00, 0.53, 0.11});
								end
								particle[3] = "air";
								particle[4] = "none";
							end
						end
					end
				end
			end
		end
	end
	for y in ipairs(particles) do
        for x in ipairs(particles[y]) do
			local particle = particles[y][x];
			if particle[3] == "sand" then
				draw_part(particle,{1.00, 0.87, 0.61});
			elseif particle[3] == "water" then
				draw_part(particle,{0.23, 0.90, 1.00});
			elseif particle[3] == "lava" then
                draw_part(particle,{1.00, 0.53, 0.11});
			elseif particle[3] == "obi" then
				draw_part(particle,{0.03, 0.00, 0.12});
			end
		end
	end
end
