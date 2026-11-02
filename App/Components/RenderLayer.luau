-- Ayden
-- RenderLayer
-- Oct 14th, 2026

-- Based off of: https://github.com/littensy/slither/blob/main/src/client/components/ui/transition.tsx

type Derivable<T> = T | () -> T

export type Props = {
	GroupColor: Derivable<Color3>?,
	GroupTransparency: Derivable<number>?,
	AnchorPoint: Derivable<Vector2>?,
	Size: Derivable<UDim2>?,
	Position: Derivable<UDim2>?,
	Rotation: Derivable<number>?,
	ClipsDescendants: Derivable<boolean>?,
	LayoutOrder: Derivable<number>?,
	ZIndex: Derivable<number>?,
	Events: {[any]: any}?,
	DirectChildren: (() -> any)?,
	children: any?
}

const ReplicatedStorage = game:GetService('ReplicatedStorage');
const Vide = require(ReplicatedStorage.Packages.vide)

const create = Vide.create
const derive = Vide.derive
const read = Vide.read

const EPSILON = 0.03
const WHITE = Color3.new(1, 1, 1)

const function RenderLayer(props: Props)
	const fill = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}

	const fading = derive(function()
		return read(props.GroupTransparency or 0) > EPSILON or read(props.GroupColor or WHITE) ~= WHITE
	end)

	const canvas = create 'CanvasGroup' {
		Name = 'CanvasLayer',
		GroupTransparency = props.GroupTransparency,
		GroupColor3 = props.GroupColor,

		fill,
		props.Events,
		props.DirectChildren
	}

	const frame = create 'Frame' {
		Name = 'FrameLayer',
		ClipsDescendants = props.ClipsDescendants,

		fill,
		props.Events,
		props.DirectChildren
	}

	create 'Frame' {
		Name = 'Content',
		Parent = function()
			return if fading() then canvas else frame
		end,

		fill,
		props.children
	}

	return create 'Frame' {
		Name = 'RenderLayer',
		BackgroundTransparency = 1,
		AnchorPoint = props.AnchorPoint,
		Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position,
		Rotation = props.Rotation,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,

		canvas,
		frame
	}
end

return RenderLayer