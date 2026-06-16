from typing import Literal

from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    postgres_user: str
    postgres_password: str
    postgres_db: str
    postgres_port: int = 5432

    environment: Literal["development", "staging", "production"] = "production"
    debug: bool = False
    

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )
    
    @property
    def is_dev(self) -> bool:
        return self.environment == "development"

    @property
    def is_staging(self) -> bool:
        return self.environment == "staging"

    @property
    def is_prod(self) -> bool:
        return self.environment == "production"

settings = Settings()