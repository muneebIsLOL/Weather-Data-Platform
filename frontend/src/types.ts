export interface Weather {
  clear_sky: string
  cloudy: string
  thunderstorm: string
  overcast: string
}

export type Unit = "metric" | "imperial"

export interface CurrentWeather {
  time: string
  apparent_temp: number
  temperature: number
  relative_humidity: number
  is_day: 0 | 1
  wind_speed: number
  wind_direction: string
  surface_pressure: number
  feels_like: string
}