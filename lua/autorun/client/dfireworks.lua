local meta = FindMetaTable( "Panel" )

function meta:Fireworks( interval, opacity, particleOpacity )
	local oldPaint = self.Paint
	self.Fireworks = {}
	self.ShouldFirework = true
	function self:PaintOver( w, h )
		if self.ShouldFirework then
			if ( self.LastFirework or 0 ) < CurTime() - interval then
				local num = #self.Fireworks + 1
				self.Fireworks[ num ] = {}
				self.Fireworks[ num ].x = math.random( 0, self:GetWide() )
				self.Fireworks[ num ].y = 0
				self.Fireworks[ num ].explode = math.Rand( self:GetTall() * 0.0015, self:GetTall() * 0.0035 )
				self.Fireworks[ num ].lifetime = 0
				self.Fireworks[ num ].colour = HSVToColor( CurTime() * 10000 % 360, 1, 1 )
				self.LastFirework = CurTime()
			end
			for i, firework in ipairs( self.Fireworks ) do
				firework.lifetime = firework.lifetime + 0.002
				if firework.lifetime >= firework.explode then
					if firework.particles then
						for _, particle in ipairs( firework.particles ) do
							surface.SetDrawColor( firework.colour.r, firework.colour.g, firework.colour.b, particle.opacity )
							particle.x = particle.x + particle.movex * 100 * RealFrameTime()
							particle.y = particle.y + particle.movey * 100 * RealFrameTime()
							particle.movex = particle.movex - RealFrameTime()
							particle.movey = particle.movey - 0.006
							particle.opacity = particle.opacity - 250 * RealFrameTime()
							if particle.opacity <= 0 then table.remove( self.Fireworks, i )  break end
							surface.DrawRect( particle.x, self:GetTall() - particle.y, 2, 2 )
						end
					else
						firework.particles = {}
						for i = 1, 200 do
							firework.particles[ i ] = {}
							firework.particles[ i ].x = firework.x + math.sin( math.rad( i * ( 360 / 200 ) ) ) + math.Rand( -0.9, 0.45 )
							firework.particles[ i ].y = firework.y + math.cos( math.rad( i * ( 360 / 200 ) ) ) + math.Rand( -0.9, 0.45 )
							firework.particles[ i ].movex = firework.particles[ i ].x - firework.x
							firework.particles[ i ].movey = firework.particles[ i ].y - firework.y
							firework.particles[ i ].opacity = particleOpacity
						end
					end
				continue end
				surface.SetDrawColor( firework.colour.r, firework.colour.g, firework.colour.b, opacity )
				surface.DrawLine( firework.x, self:GetTall() - firework.y, firework.x, self:GetTall() - firework.y - 5 )
				firework.y = firework.y + self:GetTall() * 0.0005
			end
		end
	end
end

local meme = vgui.Create( "DFrame" )
meme:SetSize( ScrW(), ScrH() )
meme:Center()
meme:MakePopup()
meme:Fireworks( 0.2, 10, 255 )
meme.Paint = function( self, w, h )
	surface.SetDrawColor( 0, 0, 0 )
	surface.DrawRect( 0, 0, w, h )
end
