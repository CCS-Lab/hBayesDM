def model_info(info):
    task_name_code = info.get('task_name', {}).get('code')
    model_name_code = info.get('model_name', {}).get('code')
    model_type_code = info.get('model_type', {}).get('code')

    # Model full name (Snake-case)
    model_function = []
    if task_name_code is not None and len(task_name_code) > 0:
        model_function.append(task_name_code)
    if model_name_code is not None and len(model_name_code) > 0:
        model_function.append(model_name_code)
    if model_type_code is not None and len(model_type_code) > 0:
        model_function.append(model_type_code)
    model_function = '_'.join(model_function)

    if model_type_code is None:
        model_type_code = ''
    return model_function, task_name_code, model_name_code, model_type_code

# Prefix to preprocess_func
def preprocess_func_prefix(info):
    task_name_code = info.get('task_name', {}).get('code')
    model_type_code = info.get('model_type', {}).get('code')

    preprocess_func_prefix = []
    if task_name_code:
        preprocess_func_prefix.append(task_name_code)
    if model_type_code:
        preprocess_func_prefix.append(model_type_code)
    return '_'.join(preprocess_func_prefix)

def extract_or_empty_string(info, key, subkey):
    return info[key][subkey] if info[key][subkey] is not None else ""
