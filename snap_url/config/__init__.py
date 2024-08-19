from .local import LocalConfig
from .dev import DevConfig
from .prod import ProdConfig

config_dict = {
    'local': LocalConfig,
    'dev': DevConfig,
    'prod': ProdConfig
}
