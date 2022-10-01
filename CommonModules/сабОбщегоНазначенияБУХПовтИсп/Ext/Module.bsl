﻿Функция СоотвСтавокНДСБУХУУ() Экспорт
	
	СоотвСтавокНДС = Новый Соответствие;
	СоотвСтавокНДС.Вставить(Перечисления.СтавкиНДС.БезНДС, сабОбщегоНазначения.ПолучитьЭлементНДС("Без НДС"));
	СоотвСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС10, сабОбщегоНазначения.ПолучитьЭлементНДС("10%"));
	СоотвСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС18, сабОбщегоНазначения.ПолучитьЭлементНДС("18%"));
	СоотвСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС20, сабОбщегоНазначения.ПолучитьЭлементНДС("20%"));
	СоотвСтавокНДС.Вставить(Перечисления.СтавкиНДС.ПустаяСсылка(), сабОбщегоНазначения.ПолучитьЭлементНДС("Без НДС"));
	Возврат СоотвСтавокНДС;

КонецФункции // ()

Функция СоотвСтавокНДСУУБУХ() Экспорт
	
	СоотвСтавокНДС = Новый Соответствие;
	СоотвСтавокНДС.Вставить(сабОбщегоНазначения.ПолучитьЭлементНДС("Без НДС"), Перечисления.СтавкиНДС.БезНДС);
	СоотвСтавокНДС.Вставить(сабОбщегоНазначения.ПолучитьЭлементНДС("10%"), Перечисления.СтавкиНДС.НДС10);
	СоотвСтавокНДС.Вставить(сабОбщегоНазначения.ПолучитьЭлементНДС("18%"), Перечисления.СтавкиНДС.НДС18);
	СоотвСтавокНДС.Вставить(сабОбщегоНазначения.ПолучитьЭлементНДС("20%"), Перечисления.СтавкиНДС.НДС20);
	СоотвСтавокНДС.Вставить(Справочники.СтавкиНДС.ПустаяСсылка(), Перечисления.СтавкиНДС.БезНДС);
	Возврат СоотвСтавокНДС;

КонецФункции // ()

Функция СоотвВидовСтавокНДСБУХУУ() Экспорт
	
	СоотвСтавокНДС = Новый Соответствие;
	СоотвСтавокНДС.Вставить(Перечисления.ВидыСтавокНДС.БезНДС, сабОбщегоНазначения.ПолучитьЭлементНДС("Без НДС"));
	СоотвСтавокНДС.Вставить(Перечисления.ВидыСтавокНДС.Пониженная, сабОбщегоНазначения.ПолучитьЭлементНДС("10%"));
	//СоотвСтавокНДС.Вставить(Перечисления.СтавкиНДС.НДС18, сабОбщегоНазначения.ПолучитьЭлементНДС("18%"));
	СоотвСтавокНДС.Вставить(Перечисления.ВидыСтавокНДС.Общая, сабОбщегоНазначения.ПолучитьЭлементНДС("20%"));
	СоотвСтавокНДС.Вставить(Перечисления.ВидыСтавокНДС.ПустаяСсылка(), сабОбщегоНазначения.ПолучитьЭлементНДС("Без НДС"));
	Возврат СоотвСтавокНДС;

КонецФункции // ()
