local meta = FindMetaTable( "Panel" )

function meta:SetVertices( verts )
	self.vertices = {}

	local radiusW = self:GetWide() / 2
	local radiusH = self:GetTall() / 2

	self.vertices[ #self.vertices + 1 ] = { x = radiusW, y = radiusH }
	for i = 0, verts do
		local a = math.rad( i / verts * -360 )
		self.vertices[ #self.vertices + 1 ] = { x = radiusW + math.sin( a ) * radiusW, y = radiusH + math.cos( a ) * radiusH }
	end
	self.vertices[ #self.vertices + 1 ] = { x = radiusW, y = radiusH }

	self:SetPaintedManually( true )
	self.vParent = vgui.Create( "Panel", self:GetParent() )
	self.vParent:SetPos( self:GetPos() )
	self.vParent:SetSize( self:GetSize() )
	self.vParent.vChild = self

	function self.vParent:Paint()
		if !self.vChild or !IsValid( self.vChild ) then return end
		render.ClearStencil()
		render.SetStencilEnable( true )

			render.SetStencilWriteMask( 1 )
			render.SetStencilTestMask( 1 )

			render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
			render.SetStencilReferenceValue( 1 )

			draw.NoTexture()
			surface.SetDrawColor( color_white )
			surface.DrawPoly( self.vChild.vertices )

			render.SetStencilFailOperation( STENCILOPERATION_ZERO )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
			render.SetStencilReferenceValue( 1 )

			self.vChild:PaintManual()

		render.SetStencilEnable( false )
	end
end