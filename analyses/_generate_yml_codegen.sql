{% set models_to_generate = codegen.get_models(prefix='dim_products') %}
{{ codegen.generate_model_yaml(
    model_names = models_to_generate
) }}