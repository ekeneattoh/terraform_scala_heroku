provider "heroku" {
  email   = var.heroku_username
  api_key = var.heroku_api_key
}

resource "heroku_app" "herokuapp" {
  name   = var.heroku_app_name
  region = var.heroku_region

  config_vars = {
    PLAY_SECRET_KEY = var.secret_key
  }

  buildpacks = [
    "heroku/scala"
  ]
}

// module "postgres_add_on" {
//   source          = "./modules/postgres_add_on/"
//   var_name = var.var_name
// }

resource "heroku_build" "herokuapp" {
  app        = heroku_app.herokuapp.id
  depends_on = [heroku_app.herokuapp]

  source = {
    # A local directory, changing its contents will
    # force a new build during `terraform apply`

    path = var.source_code_path
  }
}

resource "heroku_formation" "herokuapp" {
  app        = heroku_app.herokuapp.id
  type       = "web"
  quantity   = 1
  size       = "Standard-1x"
  depends_on = [heroku_build.herokuapp]
}
