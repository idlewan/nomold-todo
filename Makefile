TEMPLATE_DIR=src
COFFEE_DIR=src
OUTPUT_DIR=_js
CSS_DIR=_css

NAMESPACE=window.TEMPLATE

JADE = $(shell find $(TEMPLATE_DIR)/*.jade)
JADE_JS = $(JADE:$(TEMPLATE_DIR)/%.jade=$(OUTPUT_DIR)/%.jade.js)

all: $(OUTPUT_DIR) $(JADE_JS)

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)
$(CSS_DIR):
	mkdir -p $(CSS_DIR)

$(OUTPUT_DIR)/%.jade.js: $(TEMPLATE_DIR)/%.jade
	@echo "$(NAMESPACE) = $(NAMESPACE) || {};" > $@
	@echo -n "$(NAMESPACE)['$(notdir $<)'] = " >> $@
	@jade -c < $< --path $< >> $@
	@echo ";" >> $@
	@echo "compiled $<"

coffee_once: $(OUTPUT_DIR)
	coffee -l --output $(OUTPUT_DIR) --compile $(COFFEE_DIR)

coffee: $(OUTPUT_DIR)
	coffee -l -w --output $(OUTPUT_DIR) --compile $(COFFEE_DIR)

css: $(CSS_DIR)
	stylus -w --out $(CSS_DIR) ./styl/*.styl

clean:
	rm -f $(JADE_JS)

.PHONY: clean
