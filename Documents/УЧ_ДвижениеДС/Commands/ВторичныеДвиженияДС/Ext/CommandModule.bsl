﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура("", );
	ТекФорма = ПолучитьФорму("Документ.УЧ_ДвижениеДС.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	НовыйОтбор = ТекФорма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДокОснование2");
	НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НовыйОтбор.ПравоеЗначение = ПараметрКоманды;
	ТекФорма.Открыть();
КонецПроцедуры
