play_sound <- function(sound_dir = "/soundboard_files", custom_sink = "SoundBoard", obs_animate = TRUE, wait = FALSE) {
  audio_file <- sample(list.files(sound_dir, full.names = TRUE), size = 1)
  play_args <- c(audio_file)

  if (!is.null(custom_sink)) {
    play_args <- c(play_args, "-d", custom_sink)
  }

  system2("paplay", args = play_args, wait = wait)

  if (obs_animate) {
    system2("curl", paste0("http://192.168.1.178:1030/image?filename=/", audio_file), stdout = FALSE, stderr = FALSE)
  }

  invisible(TRUE)
}

options(error = play_sound)
