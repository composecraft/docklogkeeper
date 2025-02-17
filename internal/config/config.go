package config

import (
	"fmt"

	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	LogLevel  string     `yaml:"log_level" env:"LOG_LEVEL"` // trace, debug, info, warn, error, fatal, panic, disabled
	Analytics bool       `yaml:"analytics" env:"ANALYTICS"`
	Auth      AuthConfig `yaml:"auth"`
	HTTP      HTTPConfig `yaml:"http"`
	Log       LogConfig  `yaml:"log"`
	DB        DBConfig   `yaml:"db"`
	HEADLESS  bool       `yaml:"headless" env:"HEADLESS"`
}

type DBConfig struct {
	DBFile string `yaml:"db_file" env:"DB_FILE"`
	Log    bool   `yaml:"log" env:"DB_LOG"`
}

type AuthConfig struct {
	Secret   string `yaml:"secret" env:"AUTH_SECRET"`
	Password string `yaml:"password" env:"PASSWORD"`
}

type HTTPConfig struct {
	Port    int    `yaml:"port" env:"HTTP_PORT"`
	GinMode string `yaml:"gin_mode" env:"GIN_MODE"`
}

type LogConfig struct {
	Retention int64 `yaml:"retention" env:"LOG_RETENTION"`
}

func LoadConfig(configFilePath string) (Config, error) {
	var cfg Config
	err := cleanenv.ReadConfig(configFilePath, &cfg)
	if err != nil {
		return cfg, fmt.Errorf("error load config: %w", err)
	}
	return cfg, nil
}
