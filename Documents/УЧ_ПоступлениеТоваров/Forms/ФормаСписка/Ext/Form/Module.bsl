
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		Если Параметр.Свойство("ФормаВладелецУИД") И Параметр.ФормаВладелецУИД = ЭтаФорма.УникальныйИдентификатор Тогда
			сабОбщегоНазначения.ПрикрепитьФайлКДокументу(Параметр); 
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не Копирование Тогда
		Отказ = Истина;
		СоздатьНовыйДокумент(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйДокумент(Команда)
	Если Заголовок = "Основные средства" Тогда
		ТекФорма = ПолучитьФорму("Документ.УЧ_ПоступлениеТоваров.ФормаОбъекта", Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыПоступлений.ПоступлениеОС")));
	Иначе
		ТекФорма = ПолучитьФорму("Документ.УЧ_ПоступлениеТоваров.ФормаОбъекта", Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыПоступлений.ПоступлениеУслуг")));
	КонецЕсли;
	ТекФорма.Открыть();
КонецПроцедуры
