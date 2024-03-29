﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователи.ТекущийПользователь());
	Список.Параметры.УстановитьЗначениеПараметра("Предмет", "");
	Список.Параметры.УстановитьЗначениеПараметра("Пометка", Перечисления.ЦветаЗаметок.ПустаяСсылка());
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьУдаленные", Ложь);
	
	ЗаполнитьСписокВыбораФильтраПоПредмету();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент Или МобильныйКлиент Или МобильноеПриложениеКлиент Тогда 
	Элементы.ФильтрПоЦвету.СписокВыбора.Вставить(0, ПредопределенноеЗначение("Перечисление.ЦветаЗаметок.ПустаяСсылка")," ");
	#КонецЕсли
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
   	Список.Параметры.УстановитьЗначениеПараметра("Предмет", "%" + ВыбранныйПредмет + "%");
	Список.Параметры.УстановитьЗначениеПараметра("Пометка", ВыбранныйЦвет);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьУдаленные", ПоказыватьУдаленные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФильтрПоПредметуПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("Предмет", "%" + ВыбранныйПредмет + "%");
КонецПроцедуры

&НаКлиенте
Процедура ФильтрПоПредметуАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	Список.Параметры.УстановитьЗначениеПараметра("Предмет", "%" + Текст + "%");
КонецПроцедуры

&НаКлиенте
Процедура ФильтрПоЦветуПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("Пометка", ВыбранныйЦвет);
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленныеПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьУдаленные", ПоказыватьУдаленные);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораФильтраПоПредмету()
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Заметки.ПредставлениеПредмета КАК ПредставлениеПредмета
	|ИЗ
	|	Справочник.Заметки КАК Заметки
	|ГДЕ
	|	Заметки.ЭтоГруппа = ЛОЖЬ
	|	И Заметки.ПометкаУдаления = ЛОЖЬ
	|	И Заметки.Автор = &Пользователь
	|
	|СГРУППИРОВАТЬ ПО
	|	Заметки.ПредставлениеПредмета
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПредставлениеПредмета";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		Элементы.ФильтрПоПредмету.СписокВыбора.Добавить(Выборка.ПредставлениеПредмета);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
