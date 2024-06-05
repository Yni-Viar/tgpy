using Godot;
using System;

public partial class LootableAmmo : InteractableRigidBody
{
	[Export] internal int objectId;
	[Export] int ammoType;
	[Export] int amount;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	/// <summary>
	/// Adds ammo to player
	/// </summary>
	/// <param name="player">Which player</param>
	internal override void Interact(Node3D player)
	{
		player.GetNode<AmmoSystem>("AmmoSystem").ammo[ammoType] += amount;
		Rpc("DestroyPickedItem");
		base.Interact(player);
	}

    /// <summary>
    /// Removes item in the map after picking.
    /// </summary>
    [Rpc(MultiplayerApi.RpcMode.AnyPeer, CallLocal = true)]
    void DestroyPickedItem()
    {
        this.QueueFree();
    }
}
