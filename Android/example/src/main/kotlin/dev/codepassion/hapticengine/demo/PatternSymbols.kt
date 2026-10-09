package dev.codepassion.hapticengine.demo

import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.outlined.ArrowBack
import androidx.compose.material.icons.automirrored.outlined.ArrowForward
import androidx.compose.material.icons.automirrored.outlined.DirectionsRun
import androidx.compose.material.icons.automirrored.outlined.DirectionsWalk
import androidx.compose.material.icons.automirrored.outlined.FormatIndentIncrease
import androidx.compose.material.icons.automirrored.outlined.FormatListBulleted
import androidx.compose.material.icons.automirrored.outlined.LastPage
import androidx.compose.material.icons.automirrored.outlined.MenuBook
import androidx.compose.material.icons.automirrored.outlined.QueueMusic
import androidx.compose.material.icons.automirrored.outlined.RotateRight
import androidx.compose.material.icons.automirrored.outlined.Reply
import androidx.compose.material.icons.automirrored.outlined.ShowChart
import androidx.compose.material.icons.automirrored.outlined.TrendingDown
import androidx.compose.material.icons.automirrored.outlined.TrendingFlat
import androidx.compose.material.icons.automirrored.outlined.TrendingUp
import androidx.compose.material.icons.automirrored.outlined.Undo
import androidx.compose.material.icons.automirrored.outlined.VolumeDown
import androidx.compose.material.icons.automirrored.outlined.VolumeMute
import androidx.compose.material.icons.automirrored.outlined.VolumeOff
import androidx.compose.material.icons.automirrored.outlined.VolumeUp
import androidx.compose.material.icons.outlined.*
import androidx.compose.material.icons.rounded.Apps
import androidx.compose.material.icons.rounded.ArrowCircleUp
import androidx.compose.material.icons.rounded.Bolt
import androidx.compose.material.icons.rounded.ChangeHistory
import androidx.compose.material.icons.rounded.Circle
import androidx.compose.material.icons.rounded.CircleNotifications
import androidx.compose.material.icons.rounded.Coffee
import androidx.compose.material.icons.rounded.DirectionsBoatFilled
import androidx.compose.material.icons.rounded.DirectionsCarFilled
import androidx.compose.material.icons.rounded.Draw
import androidx.compose.material.icons.rounded.Eco
import androidx.compose.material.icons.rounded.Favorite
import androidx.compose.material.icons.rounded.FlutterDash
import androidx.compose.material.icons.rounded.Grid4x4
import androidx.compose.material.icons.rounded.Hardware
import androidx.compose.material.icons.rounded.LocalFireDepartment
import androidx.compose.material.icons.rounded.Mood
import androidx.compose.material.icons.rounded.Notifications
import androidx.compose.material.icons.rounded.Pets
import androidx.compose.material.icons.rounded.Phone
import androidx.compose.material.icons.automirrored.rounded.QueueMusic
import androidx.compose.material.icons.rounded.Rectangle
import androidx.compose.material.icons.rounded.SetMeal
import androidx.compose.material.icons.rounded.Square
import androidx.compose.material.icons.rounded.Star
import androidx.compose.material.icons.rounded.Stars
import androidx.compose.material.icons.rounded.ThumbUp
import androidx.compose.material.icons.rounded.TouchApp
import androidx.compose.material.icons.rounded.Tram
import androidx.compose.material.icons.rounded.TripOrigin
import androidx.compose.material.icons.rounded.WatchLater
import androidx.compose.material.icons.rounded.Water
import androidx.compose.material.icons.rounded.WaterDrop
import androidx.compose.material.icons.rounded.WbSunny
import androidx.compose.material.icons.rounded.WbTwilight
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp

/**
 * Draws an SF Symbols name, as the iOS demo uses, with the closest Material icon: outlined for a plain
 * symbol, rounded and filled for a `.fill` one. A numbered symbol, such as `5.circle`, is drawn as its
 * number in a ring or a square, as on iOS: Material has no icon for most numbers.
 */
@Composable
fun PatternSymbol(symbol: String, tint: Color, size: Dp, modifier: Modifier = Modifier) {
    val number = numberedSymbol.matchEntire(symbol)
    if (number != null) {
        val (digits, shape) = number.destructured
        val stroke = size / 12
        Box(
            modifier
                .size(size)
                .border(stroke, tint, if (shape == "circle") CircleShape else RoundedCornerShape(size / 5)),
            contentAlignment = Alignment.Center,
        ) {
            val fontSize = with(LocalDensity.current) { (size * if (digits.length > 1) 0.42f else 0.55f).toSp() }
            Text(digits, color = tint, fontSize = fontSize, fontWeight = FontWeight.Bold, maxLines = 1)
        }
    } else {
        Icon(symbolIcon(symbol), contentDescription = null, tint = tint, modifier = modifier.size(size))
    }
}

private val numberedSymbol = Regex("""(\d+)\.(circle|square)""")

/** Whether [symbol] has something to draw: a mapped icon or a number. */
fun hasSymbol(symbol: String): Boolean = numberedSymbol.matches(symbol) || mappedIcon(symbol) != null

/** The Material icon for [symbol], or a plain circle for one not mapped. */
fun symbolIcon(symbol: String): ImageVector = mappedIcon(symbol) ?: Icons.Outlined.Circle

private fun mappedIcon(symbol: String): ImageVector? = when (symbol) {
    "air.conditioner.horizontal" -> Icons.Outlined.AcUnit
    "airplane" -> Icons.Outlined.Flight
    "airplane.arrival" -> Icons.Outlined.FlightLand
    "airplane.circle" -> Icons.Outlined.AirplanemodeActive
    "airplane.departure" -> Icons.Outlined.FlightTakeoff
    "alarm" -> Icons.Outlined.Alarm
    "ant" -> Icons.Outlined.BugReport
    "antenna.radiowaves.left.and.right" -> Icons.Outlined.SettingsInputAntenna
    "app" -> Icons.Outlined.CropSquare
    "app.badge" -> Icons.Outlined.AppRegistration
    "aqi.low" -> Icons.Outlined.Air
    "aqi.medium" -> Icons.Outlined.Masks
    "arcade.stick" -> Icons.Outlined.SportsEsports
    "arrow.clockwise" -> Icons.Outlined.Refresh
    "arrow.clockwise.circle" -> Icons.Outlined.Autorenew
    "arrow.down" -> Icons.Outlined.ArrowDownward
    "arrow.down.circle" -> Icons.Outlined.ArrowCircleDown
    "arrow.down.right" -> Icons.Outlined.SouthEast
    "arrow.down.right.and.arrow.up.left" -> Icons.Outlined.CloseFullscreen
    "arrow.down.square" -> Icons.Outlined.Download
    "arrow.down.to.line" -> Icons.Outlined.VerticalAlignBottom
    "arrow.forward" -> Icons.AutoMirrored.Outlined.ArrowForward
    "arrow.left" -> Icons.AutoMirrored.Outlined.ArrowBack
    "arrow.left.arrow.right" -> Icons.Outlined.SwapHoriz
    "arrow.left.arrow.right.circle" -> Icons.Outlined.SyncAlt
    "arrow.right" -> Icons.Outlined.East
    "arrow.right.circle" -> Icons.Outlined.ArrowCircleRight
    "arrow.right.to.line" -> Icons.AutoMirrored.Outlined.LastPage
    "arrow.triangle.2.circlepath" -> Icons.Outlined.Sync
    "arrow.triangle.2.circlepath.circle" -> Icons.Outlined.Cached
    "arrow.triangle.turn.up.right.circle" -> Icons.Outlined.Directions
    "arrow.up" -> Icons.Outlined.ArrowUpward
    "arrow.up.and.down" -> Icons.Outlined.Height
    "arrow.up.and.down.and.arrow.left.and.right" -> Icons.Outlined.OpenWith
    "arrow.up.arrow.down" -> Icons.Outlined.SwapVert
    "arrow.up.arrow.down.circle" -> Icons.Outlined.ImportExport
    "arrow.up.arrow.down.square" -> Icons.Outlined.UnfoldMore
    "arrow.up.circle" -> Icons.Outlined.ArrowCircleUp
    "arrow.up.circle.fill" -> Icons.Rounded.ArrowCircleUp
    "arrow.up.left.and.arrow.down.right" -> Icons.Outlined.OpenInFull
    "arrow.up.right" -> Icons.Outlined.NorthEast
    "arrow.uturn.backward" -> Icons.AutoMirrored.Outlined.Undo
    "arrow.uturn.backward.circle" -> Icons.Outlined.Replay
    "arrow.uturn.down" -> Icons.AutoMirrored.Outlined.Reply
    "at" -> Icons.Outlined.AlternateEmail
    "barcode.viewfinder" -> Icons.Outlined.QrCodeScanner
    "baseball" -> Icons.Outlined.SportsBaseball
    "basketball" -> Icons.Outlined.SportsBasketball
    "battery.25" -> Icons.Outlined.BatteryAlert
    "beach.umbrella" -> Icons.Outlined.BeachAccess
    "bell" -> Icons.Outlined.Notifications
    "bell.and.waves.left.and.right" -> Icons.Outlined.NotificationsActive
    "bell.badge" -> Icons.Outlined.NotificationImportant
    "bell.circle" -> Icons.Outlined.CircleNotifications
    "bell.circle.fill" -> Icons.Rounded.CircleNotifications
    "bell.fill" -> Icons.Rounded.Notifications
    "bell.slash" -> Icons.Outlined.NotificationsOff
    "bicycle" -> Icons.Outlined.PedalBike
    "bird" -> Icons.Outlined.FlutterDash
    "bird.fill" -> Icons.Rounded.FlutterDash
    "bolt" -> Icons.Outlined.Bolt
    "bolt.batteryblock" -> Icons.Outlined.BatteryChargingFull
    "bolt.circle" -> Icons.Outlined.OfflineBolt
    "bolt.fill" -> Icons.Rounded.Bolt
    "bolt.heart" -> Icons.Outlined.MonitorHeart
    "bolt.horizontal" -> Icons.Outlined.FlashOn
    "book" -> Icons.AutoMirrored.Outlined.MenuBook
    "bubble" -> Icons.Outlined.ChatBubbleOutline
    "bubble.left" -> Icons.Outlined.ChatBubble
    "bubble.left.and.bubble.right" -> Icons.Outlined.Forum
    "bubbles.and.sparkles" -> Icons.Outlined.BubbleChart
    "building.2" -> Icons.Outlined.Apartment
    "burst" -> Icons.Outlined.Flare
    "bus" -> Icons.Outlined.DirectionsBus
    "button.horizontal" -> Icons.Outlined.SmartButton
    "button.programmable" -> Icons.Outlined.RadioButtonChecked
    "cablecar" -> Icons.Outlined.DirectionsRailway
    "calendar" -> Icons.Outlined.CalendarToday
    "calendar.badge.clock" -> Icons.Outlined.Event
    "camera" -> Icons.Outlined.PhotoCamera
    "capsule" -> Icons.Outlined.Medication
    "car" -> Icons.Outlined.DirectionsCar
    "car.fill" -> Icons.Rounded.DirectionsCarFilled
    "carrot" -> Icons.Outlined.Spa
    "cat" -> Icons.Outlined.Pets
    "cellularbars" -> Icons.Outlined.SignalCellularAlt
    "chart.bar" -> Icons.Outlined.BarChart
    "chart.line.downtrend.xyaxis" -> Icons.AutoMirrored.Outlined.TrendingDown
    "chart.line.flattrend.xyaxis" -> Icons.AutoMirrored.Outlined.TrendingFlat
    "chart.line.uptrend.xyaxis" -> Icons.AutoMirrored.Outlined.TrendingUp
    "checkmark.circle" -> Icons.Outlined.CheckCircle
    "checkmark.seal" -> Icons.Outlined.Verified
    "checkmark.square" -> Icons.Outlined.CheckBox
    "circle" -> Icons.Outlined.Circle
    "circle.circle" -> Icons.Outlined.TripOrigin
    "circle.circle.fill" -> Icons.Rounded.TripOrigin
    "circle.dashed" -> Icons.Outlined.BlurCircular
    "circle.dotted" -> Icons.Outlined.BlurOn
    "circle.fill" -> Icons.Rounded.Circle
    "circle.grid.2x2" -> Icons.Outlined.GridView
    "circle.grid.3x3" -> Icons.Outlined.Apps
    "circle.grid.3x3.fill" -> Icons.Rounded.Apps
    "circle.hexagongrid" -> Icons.Outlined.Hive
    "circle.inset.filled" -> Icons.Outlined.RadioButtonChecked
    "circle.lefthalf.filled" -> Icons.Outlined.Contrast
    "clock" -> Icons.Outlined.Schedule
    "clock.arrow.circlepath" -> Icons.Outlined.History
    "clock.badge" -> Icons.Outlined.AccessTime
    "clock.badge.exclamationmark" -> Icons.Outlined.AccessAlarm
    "clock.fill" -> Icons.Rounded.WatchLater
    "cloud" -> Icons.Outlined.Cloud
    "cloud.bolt" -> Icons.Outlined.Thunderstorm
    "cloud.bolt.rain" -> Icons.Outlined.Storm
    "cloud.drizzle" -> Icons.Outlined.Grain
    "cloud.fog" -> Icons.Outlined.Dehaze
    "cloud.hail" -> Icons.Outlined.Grain
    "cloud.rain" -> Icons.Outlined.Umbrella
    "cloud.sleet" -> Icons.Outlined.AcUnit
    "cloud.snow" -> Icons.Outlined.AcUnit
    "cloud.sun" -> Icons.Outlined.FilterDrama
    "cooktop" -> Icons.Outlined.OutdoorGrill
    "creditcard" -> Icons.Outlined.CreditCard
    "cross.case" -> Icons.Outlined.MedicalServices
    "crown" -> Icons.Outlined.WorkspacePremium
    "cube" -> Icons.Outlined.ViewInAr
    "cup.and.saucer" -> Icons.Outlined.Coffee
    "cup.and.saucer.fill" -> Icons.Rounded.Coffee
    "cursorarrow.click" -> Icons.Outlined.AdsClick
    "cursorarrow.click.2" -> Icons.Outlined.Mouse
    "dial.high" -> Icons.Outlined.Speed
    "dial.low" -> Icons.Outlined.Speed
    "dial.medium" -> Icons.Outlined.Speed
    "diamond" -> Icons.Outlined.Diamond
    "dishwasher" -> Icons.Outlined.Kitchen
    "doc" -> Icons.Outlined.Description
    "doc.on.doc" -> Icons.Outlined.ContentCopy
    "dog" -> Icons.Outlined.Pets
    "dollarsign.circle" -> Icons.Outlined.MonetizationOn
    "door.left.hand.closed" -> Icons.Outlined.DoorFront
    "door.left.hand.open" -> Icons.Outlined.MeetingRoom
    "door.sliding.left.hand.open" -> Icons.Outlined.DoorSliding
    "dot.radiowaves.left.and.right" -> Icons.Outlined.Sensors
    "dot.radiowaves.right" -> Icons.Outlined.WifiTethering
    "drop" -> Icons.Outlined.WaterDrop
    "drop.circle" -> Icons.Outlined.Opacity
    "drop.fill" -> Icons.Rounded.WaterDrop
    "drop.triangle" -> Icons.Outlined.InvertColors
    "ellipsis" -> Icons.Outlined.MoreHoriz
    "engine.combustion" -> Icons.Outlined.LocalGasStation
    "envelope" -> Icons.Outlined.Email
    "exclamationmark" -> Icons.Outlined.PriorityHigh
    "exclamationmark.octagon" -> Icons.Outlined.Report
    "exclamationmark.triangle" -> Icons.Outlined.WarningAmber
    "externaldrive.badge.exclamationmark" -> Icons.Outlined.SdCardAlert
    "face.smiling" -> Icons.Outlined.SentimentSatisfied
    "face.smiling.inverse" -> Icons.Rounded.Mood
    "fan" -> Icons.Outlined.Toys
    "ferry" -> Icons.Outlined.DirectionsBoat
    "ferry.fill" -> Icons.Rounded.DirectionsBoatFilled
    "figure.2.arms.open" -> Icons.Outlined.EmojiPeople
    "figure.basketball" -> Icons.Outlined.SportsBasketball
    "figure.boxing" -> Icons.Outlined.SportsMma
    "figure.climbing" -> Icons.Outlined.Hiking
    "figure.dance" -> Icons.Outlined.Celebration
    "figure.equestrian.sports" -> Icons.Outlined.Sports
    "figure.jumprope" -> Icons.Outlined.SportsGymnastics
    "figure.run" -> Icons.AutoMirrored.Outlined.DirectionsRun
    "figure.run.circle" -> Icons.Outlined.Directions
    "figure.skateboarding" -> Icons.Outlined.Skateboarding
    "figure.soccer" -> Icons.Outlined.SportsSoccer
    "figure.stairs" -> Icons.Outlined.Stairs
    "figure.stand" -> Icons.Outlined.Accessibility
    "figure.walk" -> Icons.AutoMirrored.Outlined.DirectionsWalk
    "figure.walk.arrival" -> Icons.Outlined.TransferWithinAStation
    "figure.walk.circle" -> Icons.Outlined.Hiking
    "figure.walk.motion" -> Icons.Outlined.NordicWalking
    "filemenu.and.selection" -> Icons.Outlined.Checklist
    "film" -> Icons.Outlined.Movie
    "fish" -> Icons.Outlined.SetMeal
    "fish.fill" -> Icons.Rounded.SetMeal
    "flag" -> Icons.Outlined.Flag
    "flag.checkered" -> Icons.Outlined.SportsScore
    "flame" -> Icons.Outlined.LocalFireDepartment
    "flame.fill" -> Icons.Rounded.LocalFireDepartment
    "fork.knife" -> Icons.Outlined.Restaurant
    "frying.pan" -> Icons.Outlined.SoupKitchen
    "gamecontroller" -> Icons.Outlined.SportsEsports
    "gearshape" -> Icons.Outlined.Settings
    "gearshape.2" -> Icons.Outlined.MiscellaneousServices
    "globe" -> Icons.Outlined.Public
    "globe.americas" -> Icons.Outlined.TravelExplore
    "guitars" -> Icons.AutoMirrored.Outlined.QueueMusic
    "guitars.fill" -> Icons.AutoMirrored.Rounded.QueueMusic
    "hammer" -> Icons.Outlined.Hardware
    "hammer.circle" -> Icons.Outlined.Gavel
    "hammer.fill" -> Icons.Rounded.Hardware
    "hand.draw" -> Icons.Outlined.Gesture
    "hand.draw.fill" -> Icons.Rounded.Draw
    "hand.point.right" -> Icons.Outlined.PanToolAlt
    "hand.point.up" -> Icons.Outlined.TouchApp
    "hand.point.up.left" -> Icons.Outlined.Swipe
    "hand.raised" -> Icons.Outlined.PanTool
    "hand.raised.fingers.spread" -> Icons.Outlined.FrontHand
    "hand.raised.slash" -> Icons.Outlined.DoNotTouch
    "hand.tap" -> Icons.Outlined.TouchApp
    "hand.tap.fill" -> Icons.Rounded.TouchApp
    "hand.thumbsup" -> Icons.Outlined.ThumbUp
    "hand.thumbsup.fill" -> Icons.Rounded.ThumbUp
    "hands.clap" -> Icons.Outlined.SignLanguage
    "hare" -> Icons.Outlined.CrueltyFree
    "headphones" -> Icons.Outlined.Headphones
    "heart" -> Icons.Outlined.FavoriteBorder
    "heart.circle" -> Icons.Outlined.VolunteerActivism
    "heart.fill" -> Icons.Rounded.Favorite
    "heart.slash" -> Icons.Outlined.HeartBroken
    "hexagon" -> Icons.Outlined.Hexagon
    "hourglass" -> Icons.Outlined.HourglassEmpty
    "hourglass.bottomhalf.filled" -> Icons.Outlined.HourglassBottom
    "humidity" -> Icons.Outlined.Water
    "humidity.fill" -> Icons.Rounded.Water
    "icloud.and.arrow.up" -> Icons.Outlined.CloudUpload
    "iphone.radiowaves.left.and.right" -> Icons.Outlined.Vibration
    "key" -> Icons.Outlined.Key
    "keyboard" -> Icons.Outlined.Keyboard
    "leaf" -> Icons.Outlined.Eco
    "leaf.fill" -> Icons.Rounded.Eco
    "light.beacon.max" -> Icons.Outlined.Emergency
    "lightbulb" -> Icons.Outlined.Lightbulb
    "lightswitch.off" -> Icons.Outlined.ToggleOff
    "lightswitch.on" -> Icons.Outlined.ToggleOn
    "line.3.horizontal" -> Icons.Outlined.Menu
    "line.3.horizontal.decrease" -> Icons.Outlined.FilterList
    "lines.measurement.horizontal" -> Icons.Outlined.Straighten
    "link" -> Icons.Outlined.Link
    "link.circle" -> Icons.Outlined.AddLink
    "list.bullet" -> Icons.AutoMirrored.Outlined.FormatListBulleted
    "list.bullet.indent" -> Icons.AutoMirrored.Outlined.FormatIndentIncrease
    "lizard" -> Icons.Outlined.BugReport
    "lock" -> Icons.Outlined.Lock
    "lock.open" -> Icons.Outlined.LockOpen
    "lock.rectangle" -> Icons.Outlined.Password
    "lungs" -> Icons.Outlined.Air
    "medal" -> Icons.Outlined.MilitaryTech
    "megaphone" -> Icons.Outlined.Campaign
    "message" -> Icons.Outlined.Sms
    "metronome" -> Icons.Outlined.AvTimer
    "metronome.fill" -> Icons.Outlined.Timer
    "microwave" -> Icons.Outlined.Microwave
    "moon" -> Icons.Outlined.DarkMode
    "moon.stars" -> Icons.Outlined.NightsStay
    "moon.zzz" -> Icons.Outlined.Bedtime
    "mountain.2" -> Icons.Outlined.Landscape
    "mouth" -> Icons.Outlined.RecordVoiceOver
    "music.mic" -> Icons.Outlined.Mic
    "music.note" -> Icons.Outlined.MusicNote
    "music.note.list" -> Icons.Outlined.LibraryMusic
    "music.quarternote.3" -> Icons.Outlined.Audiotrack
    "network" -> Icons.Outlined.Hub
    "newspaper" -> Icons.Outlined.Newspaper
    "nose" -> Icons.Outlined.Face
    "nosign" -> Icons.Outlined.Block
    "note.text" -> Icons.Outlined.EditNote
    "number" -> Icons.Outlined.Tag
    "opticaldisc" -> Icons.Outlined.Album
    "paperclip" -> Icons.Outlined.AttachFile
    "paperplane" -> Icons.Outlined.NearMe
    "parkingsign" -> Icons.Outlined.LocalParking
    "pawprint" -> Icons.Outlined.Pets
    "pawprint.fill" -> Icons.Rounded.Pets
    "person.crop.circle" -> Icons.Outlined.AccountCircle
    "phone" -> Icons.Outlined.Phone
    "phone.down" -> Icons.Outlined.CallEnd
    "phone.fill" -> Icons.Rounded.Phone
    "pianokeys" -> Icons.Outlined.Piano
    "plus.circle" -> Icons.Outlined.AddCircleOutline
    "plus.forwardslash.minus" -> Icons.Outlined.Exposure
    "power" -> Icons.Outlined.PowerSettingsNew
    "power.circle" -> Icons.Outlined.ModeStandby
    "power.dotted" -> Icons.Outlined.PowerOff
    "powerplug" -> Icons.Outlined.Power
    "printer" -> Icons.Outlined.Print
    "puzzlepiece" -> Icons.Outlined.Extension
    "rainbow" -> Icons.Outlined.Looks
    "recordingtape" -> Icons.Outlined.Voicemail
    "rectangle.compress.vertical" -> Icons.Outlined.Compress
    "rectangle.fill" -> Icons.Rounded.Rectangle
    "rectangle.grid.1x2" -> Icons.Outlined.ViewAgenda
    "rectangle.lefthalf.inset.filled" -> Icons.Outlined.VerticalSplit
    "rectangle.portrait" -> Icons.Outlined.CropPortrait
    "rectangle.split.2x1" -> Icons.Outlined.Splitscreen
    "rectangle.split.3x1" -> Icons.Outlined.ViewWeek
    "rectangle.split.3x3" -> Icons.Outlined.GridOn
    "road.lanes" -> Icons.Outlined.AddRoad
    "rotate.right" -> Icons.AutoMirrored.Outlined.RotateRight
    "ruler" -> Icons.Outlined.Straighten
    "scissors" -> Icons.Outlined.ContentCut
    "scooter" -> Icons.Outlined.ElectricScooter
    "scope" -> Icons.Outlined.GpsFixed
    "screwdriver" -> Icons.Outlined.Build
    "scribble" -> Icons.Outlined.Gesture
    "scribble.variable" -> Icons.Outlined.Draw
    "scroll" -> Icons.Outlined.HistoryEdu
    "shield" -> Icons.Outlined.Shield
    "shield.lefthalf.filled" -> Icons.Outlined.Security
    "shield.righthalf.filled" -> Icons.Outlined.GppGood
    "shippingbox" -> Icons.Outlined.Inventory2
    "shoeprints.fill" -> Icons.AutoMirrored.Outlined.DirectionsWalk
    "shuffle" -> Icons.Outlined.Shuffle
    "slider.horizontal.3" -> Icons.Outlined.Tune
    "slider.vertical.3" -> Icons.Outlined.Equalizer
    "smallcircle.filled.circle" -> Icons.Outlined.RadioButtonChecked
    "smoke" -> Icons.Outlined.Cloud
    "snowflake" -> Icons.Outlined.AcUnit
    "soccerball" -> Icons.Outlined.SportsSoccer
    "sos" -> Icons.Outlined.Sos
    "sparkle" -> Icons.Outlined.AutoAwesome
    "sparkles" -> Icons.Outlined.AutoAwesome
    "speaker.slash" -> Icons.AutoMirrored.Outlined.VolumeOff
    "speaker.wave.1" -> Icons.AutoMirrored.Outlined.VolumeMute
    "speaker.wave.2" -> Icons.AutoMirrored.Outlined.VolumeDown
    "speaker.wave.2.circle" -> Icons.Outlined.SpeakerPhone
    "speaker.wave.3" -> Icons.AutoMirrored.Outlined.VolumeUp
    "speedometer" -> Icons.Outlined.Speed
    "spigot" -> Icons.Outlined.Plumbing
    "sportscourt" -> Icons.Outlined.Sports
    "square.and.arrow.down" -> Icons.Outlined.Download
    "square.and.arrow.up" -> Icons.Outlined.IosShare
    "square.dashed.inset.filled" -> Icons.Outlined.SelectAll
    "square.fill" -> Icons.Rounded.Square
    "square.grid.2x2" -> Icons.Outlined.GridView
    "square.grid.3x3" -> Icons.Outlined.GridOn
    "square.grid.3x3.fill" -> Icons.Rounded.Apps
    "square.grid.4x3.fill" -> Icons.Rounded.Grid4x4
    "square.on.square" -> Icons.Outlined.FilterNone
    "square.split.1x2" -> Icons.Outlined.HorizontalSplit
    "square.stack" -> Icons.Outlined.Layers
    "stairs" -> Icons.Outlined.Stairs
    "star" -> Icons.Outlined.StarOutline
    "star.circle" -> Icons.Outlined.Stars
    "star.circle.fill" -> Icons.Rounded.Stars
    "star.fill" -> Icons.Rounded.Star
    "stopwatch" -> Icons.Outlined.Timer
    "sun.max" -> Icons.Outlined.WbSunny
    "sun.max.fill" -> Icons.Rounded.WbSunny
    "sunrise" -> Icons.Outlined.WbTwilight
    "sunset" -> Icons.Rounded.WbTwilight
    "switch.2" -> Icons.Outlined.ToggleOn
    "takeoutbag.and.cup.and.straw" -> Icons.Outlined.TakeoutDining
    "target" -> Icons.Outlined.TrackChanges
    "tennisball" -> Icons.Outlined.SportsTennis
    "thermometer.snowflake" -> Icons.Outlined.Thermostat
    "thermometer.sun" -> Icons.Outlined.DeviceThermostat
    "timer" -> Icons.Outlined.Timer
    "tornado" -> Icons.Outlined.Tornado
    "tortoise" -> Icons.Outlined.Spa
    "tram" -> Icons.Outlined.Tram
    "tram.fill" -> Icons.Rounded.Tram
    "trash" -> Icons.Outlined.DeleteOutline
    "tree" -> Icons.Outlined.Park
    "triangle" -> Icons.Outlined.ChangeHistory
    "triangle.fill" -> Icons.Rounded.ChangeHistory
    "trophy" -> Icons.Outlined.EmojiEvents
    "tshirt" -> Icons.Outlined.Checkroom
    "tv" -> Icons.Outlined.Tv
    "volleyball" -> Icons.Outlined.SportsVolleyball
    "wand.and.rays" -> Icons.Outlined.AutoFixHigh
    "wand.and.stars" -> Icons.Outlined.AutoFixNormal
    "washer" -> Icons.Outlined.LocalLaundryService
    "water.waves" -> Icons.Outlined.Waves
    "water.waves.and.arrow.down" -> Icons.Outlined.Water
    "water.waves.and.arrow.up" -> Icons.Outlined.Tsunami
    "waterbottle" -> Icons.Outlined.LocalDrink
    "waveform" -> Icons.Outlined.GraphicEq
    "waveform.path" -> Icons.AutoMirrored.Outlined.ShowChart
    "waveform.path.ecg" -> Icons.Outlined.MonitorHeart
    "wind" -> Icons.Outlined.Air
    "wineglass" -> Icons.Outlined.WineBar
    "wrench" -> Icons.Outlined.Build
    "wrench.adjustable" -> Icons.Outlined.Handyman
    "wrench.and.screwdriver" -> Icons.Outlined.Construction
    "xmark" -> Icons.Outlined.Close
    "xmark.bin" -> Icons.Outlined.DeleteForever
    "xmark.circle" -> Icons.Outlined.HighlightOff
    "xmark.octagon" -> Icons.Outlined.Dangerous
    else -> null
}
