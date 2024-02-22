﻿
&НаСервере
Процедура УУ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Группа = Элементы.Добавить(
	"УпрГруппа",
	Тип("ГруппаФормы"),
	ЭтаФорма);
	
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Поведение  = ПоведениеОбычнойГруппы.Свертываемая;
	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	Группа.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
	Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
	
	Группа.Заголовок = "Реквизиты (Управленка):";
	
	ПолеВвода = Элементы.Добавить("ПриоритетныйПорядокРасчетов", Тип("ПолеФормы"), Группа); 
	ПолеВвода.Заголовок = "Приоритетный порядок расчетов";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ПриоритетныйПорядокРасчетов"; 
	
	ПолеВвода = Элементы.Добавить("СчетВзаиморасчетов", Тип("ПолеФормы"), Группа); 
	ПолеВвода.Заголовок = "Счет взаиморасчетов";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.СчетВзаиморасчетов";
	
		
	Выборка = ПолучитьСчетаВзаиморасчетов();
	Пока Выборка.Следующий() Цикл
		ПолеВВода.СписокВыбора.Добавить(Выборка.Ссылка, Выборка.Код + " " + Выборка.Наименование);	
	КонецЦикла;
	Если ПолеВВода.СписокВыбора.Количество() Тогда
		//Удалось получить список счетов взаиморасчетов, ограничем выбор
		ПолеВвода.РежимВыбораИзСписка = Истина;
	КонецЕсли;
	
	ПолеВвода = Элементы.Добавить("СтатьяДДС", Тип("ПолеФормы"), Группа); 
	ПолеВвода.Заголовок = "Статья ДДС";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.СтатьяДДС"; 
	
	ПолеВвода = Элементы.Добавить("УЧ_Договор", Тип("ПолеФормы"), Группа); 
	ПолеВвода.Заголовок = "Договор (упр.)";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.УЧ_Договор";
	
	ПолеВвода = Элементы.Добавить("ПорядокОплатыПоДоговору", Тип("ПолеФормы"), Группа); 
	ПолеВвода.Заголовок = "Порядок оплаты по договору";
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ПорядокОплатыПоДоговору"; 
	
	ПолеВвода = Элементы.Добавить("Госконтракт", Тип("ПолеФормы"), Группа); 
	ПолеВвода.Заголовок = "Госконтракт";
	ПолеВвода.Вид = ВидПоляФормы.ПолеФлажка;
	//ПолеВвода.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Право;
	ПолеВвода.ВидФлажка = ВидФлажка.Тумблер;
	ПолеВвода.ПутьКДанным = "Объект.Госконтракт";
	
	Группа = Элементы.Добавить(
	"саб_Таблицы",
	Тип("ГруппаФормы"),
	Группа);
	
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Поведение  = ПоведениеОбычнойГруппы.Всплывающая;
	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
	Группа.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
	Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
	Группа.Заголовок = "График оплат";
	Группа.ПутьКДаннымЗаголовка = "Объект.сабГрафикОплаты.КоличествоСтрок";
	
	ТаблицаУслуги = Элементы.Добавить("сабГрафикОплаты", Тип("ТаблицаФормы"), Группа);
	ТаблицаУслуги.ПутьКДанным = "Объект.сабГрафикОплаты";
	//ТаблицаУслуги.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	
	ЭлементТаблицыФормы = Элементы.Добавить("сабГрафикОплатыДата", Тип("ПолеФормы"),ТаблицаУслуги);
	ЭлементТаблицыФормы.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементТаблицыФормы.ПутьКДанным = "Объект.сабГрафикОплаты.Дата";
	
	ЭлементТаблицыФормы = Элементы.Добавить("сабГрафикОплатыСумма", Тип("ПолеФормы"),ТаблицаУслуги);
	ЭлементТаблицыФормы.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементТаблицыФормы.ПутьКДанным = "Объект.сабГрафикОплаты.Сумма";
	
КонецПроцедуры    

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьСчетаВзаиморасчетов()
	
	УстановитьПривилегированныйРежим(Истина);
		
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УчетныйВидыСубконто.Ссылка КАК Ссылка,
	               |	УчетныйВидыСубконто.Ссылка.Код КАК Код,
	               |	УчетныйВидыСубконто.Ссылка.Наименование КАК Наименование
	               |ИЗ
	               |	ПланСчетов.Учетный.ВидыСубконто КАК УчетныйВидыСубконто
	               |ГДЕ
	               |	УчетныйВидыСубконто.ВидСубконто = &ВидСубконто
	               |	И НЕ УчетныйВидыСубконто.Ссылка.Забалансовый
	               |	И НЕ УчетныйВидыСубконто.Ссылка.ЗапретитьИспользоватьВПроводках"; 
	
	ВидСубконтоДоговоры = ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры");
	
	Запрос.УстановитьПараметр("ВидСубконто", ВидСубконтоДоговоры); 
	Выборка = Запрос.Выполнить().Выбрать();
	
	УстановитьПривилегированныйРежим(Ложь);

	Возврат Выборка
	
КонецФункции

&НаКлиенте
Процедура УУ_ПослеЗаписиПосле(ПараметрыЗаписи)
	Оповестить("Пересчитать", Объект.Ссылка);
КонецПроцедуры
#КонецОбласти

