package com.teqsonic.goalcompass.alerts

import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import com.teqsonic.goalcompass.store.EventQueue

/** Quick-settings tile: start/stop a manual focus session. */
class FocusTileService : TileService() {
    override fun onStartListening() = refresh()

    override fun onClick() {
        if (FocusNotification.isActive(this)) {
            FocusNotification.hide(this)
            EventQueue.add(this, "focus_stop")
        } else {
            FocusNotification.show(this, "Focus session running")
            EventQueue.add(this, "focus_start") { put("source", "tile") }
        }
        refresh()
    }

    private fun refresh() {
        val t = qsTile ?: return
        t.state = if (FocusNotification.isActive(this)) Tile.STATE_ACTIVE else Tile.STATE_INACTIVE
        t.label = "Focus"
        t.updateTile()
    }
}
