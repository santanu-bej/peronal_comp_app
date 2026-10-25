const planTool = {
  'name': 'save_plan',
  'description': 'Save the goal plan.',
  'input_schema': {
    'type': 'object',
    'required': ['stages', 'todos', 'digest'],
    'properties': {
      'stages': {
        'type': 'array', 'minItems': 3, 'maxItems': 7,
        'items': {
          'type': 'object', 'required': ['t', 'due', 'w', 'done_when'],
          'properties': {
            't': {'type': 'string', 'maxLength': 80},
            'due': {'type': 'string', 'description': 'YYYY-MM-DD'},
            'w': {'type': 'integer', 'minimum': 5, 'maximum': 60},
            'done_when': {'type': 'string', 'maxLength': 90},
          },
        },
      },
      'todos': {
        'type': 'array', 'minItems': 3, 'maxItems': 8,
        'items': {
          'type': 'object', 'required': ['t', 'stage', 'e'],
          'properties': {
            't': {'type': 'string', 'maxLength': 80},
            'stage': {'type': 'integer', 'description': '0-based stage index'},
            'e': {'type': 'integer', 'description': 'estimate minutes'},
          },
        },
      },
      'digest': {'type': 'string', 'maxLength': 700},
    },
  },
};

const digestTool = {
  'name': 'save_digest',
  'description': 'Save the goal digest.',
  'input_schema': {
    'type': 'object',
    'required': ['digest'],
    'properties': {'digest': {'type': 'string', 'maxLength': 700}},
  },
};

const scoresTool = {
  'name': 'save_scores',
  'description': 'Save alignment scores.',
  'input_schema': {
    'type': 'object',
    'required': ['r'],
    'properties': {
      'r': {
        'type': 'array',
        'items': {
          'type': 'object', 'required': ['i', 's', 'g', 'why'],
          'properties': {
            'i': {'type': 'integer'},
            's': {'type': 'integer', 'minimum': 0, 'maximum': 100},
            'g': {'type': ['string', 'null'], 'description': 'G1..Gn or null'},
            'why': {'type': 'string', 'maxLength': 120},
          },
        },
      },
    },
  },
};

const replanTool = {
  'name': 'save_replan',
  'description': 'Save the replan proposal.',
  'input_schema': {
    'type': 'object',
    'required': ['summary'],
    'properties': {
      'summary': {'type': 'string', 'maxLength': 300},
      'changes': {
        'type': 'array',
        'items': {
          'type': 'object', 'required': ['stage'],
          'properties': {
            'stage': {'type': 'integer'},
            'due': {'type': 'string'},
            't': {'type': 'string'},
            'drop': {'type': 'boolean'},
          },
        },
      },
      'add': {
        'type': 'array', 'maxItems': 2,
        'items': {
          'type': 'object', 'required': ['t', 'due', 'w'],
          'properties': {'t': {'type': 'string'}, 'due': {'type': 'string'}, 'w': {'type': 'integer'}},
        },
      },
      'new_todos': {
        'type': 'array', 'maxItems': 4,
        'items': {
          'type': 'object', 'required': ['t', 'stage', 'e'],
          'properties': {'t': {'type': 'string'}, 'stage': {'type': 'integer'}, 'e': {'type': 'integer'}},
        },
      },
      'move_deadline': {'type': 'string'},
    },
  },
};

const classesTool = {
  'name': 'save_classes',
  'description': 'Save content classes.',
  'input_schema': {
    'type': 'object',
    'required': ['r'],
    'properties': {
      'r': {
        'type': 'array',
        'items': {
          'type': 'object', 'required': ['i', 'c'],
          'properties': {
            'i': {'type': 'integer'},
            'c': {'type': 'string', 'enum': ['work', 'learning', 'entertainment', 'social', 'other']},
          },
        },
      },
    },
  },
};

const reviewTool = {
  'name': 'save_review',
  'description': 'Save the weekly review.',
  'input_schema': {
    'type': 'object',
    'required': ['insights', 'actions'],
    'properties': {
      'insights': {'type': 'array', 'minItems': 3, 'maxItems': 3, 'items': {'type': 'string', 'maxLength': 160}},
      'actions': {'type': 'array', 'minItems': 3, 'maxItems': 3, 'items': {'type': 'string', 'maxLength': 160}},
    },
  },
};
